{
  flake.nixosModules.fpatcher = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.fpatcher;

    jsonFmt = pkgs.formats.json {};
    tomlFmt = pkgs.formats.toml {};
    yamlFmt = pkgs.formats.yaml {};

    iniFn = ''
      set_ini() {
        local f=$1 tmp
        tmp=$(mktemp)
        SEC="$2" KEY="$3" VAL="$4" awk '
          BEGIN { sec = ENVIRON["SEC"]; key = ENVIRON["KEY"]; val = ENVIRON["VAL"] }
          { lines[NR] = $0 }
          END {
            cur = ""; sec_line = 0; key_line = 0
            for (i = 1; i <= NR; i++) {
              l = lines[i]
              if (l ~ /^\[.*\]/) {
                cur = l; sub(/^\[/, "", cur); sub(/\].*$/, "", cur)
                if (cur == sec && !sec_line) sec_line = i
                continue
              }
              if (cur == sec && !key_line && index(l, key "=") == 1) key_line = i
            }
            if (key_line) {
              lines[key_line] = key "=" val
              for (i = 1; i <= NR; i++) print lines[i]
            } else if (sec_line) {
              for (i = 1; i <= NR; i++) {
                print lines[i]
                if (i == sec_line) print key "=" val
              }
            } else {
              for (i = 1; i <= NR; i++) print lines[i]
              if (NR > 0 && lines[NR] != "") print ""
              print "[" sec "]"
              print key "=" val
            }
          }
        ' "$f" > "$tmp"
        cat "$tmp" > "$f"
        rm -f "$tmp"
      }
    '';

    formats = {
      ini = {content, ...}: let
        gen = jsonFmt.generate "content.json" content;
      in ''
        ${iniFn}
        jq -r 'to_entries[] | .key as $s | .value | to_entries[]
               | [$s, .key, (.value | tostring)] | @tsv' ${gen} |
        while IFS=$'\t' read -r sec key val; do
          set_ini "$file" "$sec" "$key" "$val"
        done
      '';

      json = {content, ...}: let
        gen = jsonFmt.generate "content.json" content;
      in ''
        if [ -s "$file" ]; then
          tmp=$(mktemp)
          jq -s '.[0] * .[1]' "$file" ${gen} > "$tmp"
          cat "$tmp" > "$file"; rm -f "$tmp"
        else
          cat ${gen} > "$file"
        fi
      '';

      toml = {content, ...}: let
        gen = tomlFmt.generate "content.toml" content;
      in ''
        if [ -s "$file" ]; then
          tmp=$(mktemp)
          yq -p toml -o toml eval-all 'select(fi==0) * select(fi==1)' "$file" ${gen} > "$tmp"
          cat "$tmp" > "$file"; rm -f "$tmp"
        else
          cat ${gen} > "$file"
        fi
      '';

      yaml = {content, ...}: let
        gen = yamlFmt.generate "content.yaml" content;
      in ''
        if [ -s "$file" ]; then
          tmp=$(mktemp)
          yq eval-all 'select(fi==0) * select(fi==1)' "$file" ${gen} > "$tmp"
          cat "$tmp" > "$file"; rm -f "$tmp"
        else
          cat ${gen} > "$file"
        fi
      '';

      # свой shell-код (sed, awk и т.д.), $file доступен
      custom = {script, ...}: script;
    };
    mkScript = name: e: let
      home = config.users.users.${e.user}.home;
      file = "${home}/${e.path}";
    in
      pkgs.writeShellApplication {
        name = "fpatcher-${name}";
        runtimeInputs = with pkgs; [coreutils gawk gnused gnugrep jq yq-go];
        text = ''
          file=${lib.escapeShellArg file}
          mkdir -p "$(dirname "$file")"
          [ -e "$file" ] || touch "$file"
          ${formats.${e.format} e}
        '';
      };
  in {
    options.fpatcher = lib.mkOption {
      default = {};
      description = "Правка файлов конфигурации при активации системы (без симлинков).";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          user = lib.mkOption {
            type = lib.types.str;
            description = "Владелец файла, правка выполняется от его имени.";
          };
          path = lib.mkOption {
            type = lib.types.str;
            description = "Путь к файлу относительно домашней директории.";
          };
          format = lib.mkOption {
            type = lib.types.enum (builtins.attrNames formats);
            description = "Формат файла.";
          };
          content = lib.mkOption {
            type = jsonFmt.type;
            default = {};
            description = "Что вливается в файл (для ini: секция -> ключ -> значение).";
          };
          script = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Shell-код для format = \"custom\"; переменная $file указывает на файл.";
          };
        };
      });
    };
    config.system.activationScripts =
      lib.mapAttrs'
      (name: e:
        lib.nameValuePair "fpatcher-${name}" {
          deps = ["users"];
          text = ''
            if [ -d ${lib.escapeShellArg config.users.users.${e.user}.home} ]; then
              ${pkgs.util-linux}/bin/runuser -u ${e.user} -- \
                ${mkScript name e}/bin/fpatcher-${name}
            fi
          '';
        })
      cfg;
  };
}
