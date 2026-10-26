{
  flake.nixosModules.fpatcher = {
    lib,
    pkgs,
    config,
    ...
  }: let
    formats = let
      toJSON = pkgs.formats.json {};
      toINI = pkgs.formats.ini {};
      toTOML = pkgs.formats.toml {};
      toYAML = pkgs.formats.yaml {};

      jq = lib.getExe pkgs.jq;
      yq = lib.getExe' pkgs.yq-go "yq";
      crudini = lib.getExe pkgs.crudini;
      toml2json = lib.getExe' pkgs.remarshal "toml2json";
      json2toml = lib.getExe' pkgs.remarshal "json2toml";
      mkFormat = {
        gen,
        merge,
        before,
        after,
      }: ''
        tmp=$(mktemp)
        trap 'rm -f "$tmp"' EXIT

        if [ -s "$file" ]; then
          ${merge}
        else
          cat ${gen} > "$tmp"
        fi

        if cmp -s "$tmp" "$file"; then
          exit 0
        fi

        # before
        ${before}

        # write
        cat "$tmp" > "$file"

        # after
        ${after}
      '';
    in {
      json = {
        content,
        before,
        after,
        ...
      }: let
        gen = toJSON.generate "content.json" content;
      in
        mkFormat {
          inherit gen before after;
          merge = ''
            ${jq} -s '.[0] * .[1]' "$file" ${gen} > "$tmp"
          '';
        };
      ini = {
        content,
        before,
        after,
        ...
      }: let
        gen = toINI.generate "content.ini" content;
      in
        mkFormat {
          inherit gen before after;
          merge = ''
            cp "$file" "$tmp"
            ${crudini} --merge "$tmp" < ${gen}
          '';
        };
      toml = {
        content,
        before,
        after,
        ...
      }: let
        gen = toTOML.generate "content.toml" content;
      in
        mkFormat {
          inherit gen before after;
          merge = ''
            ${jq} -s '.[0] * .[1]' \
              <(${toml2json} < "$file") \
              <(${toml2json} < ${gen}) \
              | ${json2toml} > "$tmp"
          '';
        };
      yaml = {
        content,
        before,
        after,
        ...
      }: let
        gen = toYAML.generate "content.yaml" content;
      in
        mkFormat {
          inherit gen before after;
          merge = ''
            ${yq} eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$file" ${gen} > "$tmp"
          '';
        };
    };
  in {
    options.fpatcher = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
          };
          format = lib.mkOption {
            type = lib.types.enum (builtins.attrNames formats);
          };
          content = lib.mkOption {
            type = lib.types.anything;
          };
          before = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Shell-код перед изменением файла. Доступна переменная $file.";
          };
          after = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Shell-код после успешного изменения файла. Доступна переменная $file.";
          };
        };
      });
      default = {};
    };
    config = lib.mkIf (config.fpatcher != {}) {
      system.userActivationScripts.fpatcher = let
        mkPath = p: let
          esc = lib.escape [''"'' "$" "`" "\\"];
          rel =
            if lib.hasPrefix "~/" p
            then lib.removePrefix "~/" p
            else if lib.hasPrefix "$HOME/" p
            then lib.removePrefix "$HOME/" p
            else if p == "~" || p == "$HOME"
            then ""
            else null;
        in
          if lib.hasPrefix "/" p
          then lib.escapeShellArg p
          else if rel != null
          then ''"$HOME/${esc rel}"''
          else ''"$HOME/${esc p}"'';

        mkEntry = name: entry: let
          script =
            pkgs.writeShellScript
            "fpatcher-${lib.strings.sanitizeDerivationName name}" ''
              set -euo pipefail
              export PATH=${lib.makeBinPath [pkgs.coreutils]}:$PATH

              file=${mkPath entry.path}
              if [ -L "$file" ]; then
                echo "fpatcher: '${name}': $file is a symlink, skipping" >&2
                exit 0
              fi
              mkdir -p "$(dirname "$file")"

              ${formats.${entry.format} entry}
            '';
        in ''
          # fpatcher: ${name}
          ${script} || echo "fpatcher: '${name}' failed" >&2
        '';
      in {
        text = lib.concatStringsSep "\n" (lib.mapAttrsToList mkEntry config.fpatcher);
      };
    };
  };
}
