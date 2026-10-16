{self, ...}: {
  flake.wrappers.sshot = {
    lib,
    wlib,
    config,
    pkgs,
    ...
  }: {
    imports = [wlib.modules.default];
    options.settings = {
      slurp = lib.mkOption {
        type = lib.types.package;
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.slurp or pkgs.slurp;
      };
      appName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      format = lib.mkOption {
        type = lib.types.str;
        default = "%Y-%m-%d_%H-%M-%S";
      };
      directory = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "$HOME/Pictures/Screenshots";
        description = "null: не сохранять на диск, только в буфер обмена";
      };
    };
    config = let
      cfg = config.settings;
    in {
      package = pkgs.writeShellApplication {
        name = "sshot";
        runtimeInputs = [cfg.slurp] ++ (with pkgs; [grim wl-clipboard libnotify coreutils]);
        text = ''
          app=""
          format="%Y-%m-%d_%H-%M-%S"
          dir=""

          while [ $# -gt 0 ]; do
            case "$1" in
              -a|--app-name)  app="''${2:?need app name}";   shift 2 ;;
              -f|--format)    format="''${2:?need format}";  shift 2 ;;
              -d|--directory) dir="''${2:?need directory}";  shift 2 ;;
              *) echo "sshot: unknown argument: $1" >&2; exit 2 ;;
            esac
          done
          
          dir="''${dir/#\~/$HOME}"
          dir="''${dir/#\$HOME/$HOME}"
          dir="''${dir/#\$\{HOME\}/$HOME}"

          if [ -z "$dir" ]; then
            file="$(mktemp --suffix=.png)"
            trap 'rm -f "$file"' EXIT
          else
            mkdir -p "$dir"
            file="$dir/$(date +"$format").png"
          fi

          region="$(slurp)" || exit 0
          grim -g "$region" "$file"
          wl-copy < "$file"
          notify_args=(-i "$file")
          if [ -n "$app" ]; then
            notify_args+=(-a "$app")
          fi
          notify-send "''${notify_args[@]}" "Screenshot captured" \
            "You can paste the image from the clipboard"
        '';
      };

      flags =
        {
          "--format" = cfg.format;
        }
        // lib.optionalAttrs (cfg.directory != null) {
          "--directory" = cfg.directory;
        }
        // lib.optionalAttrs (cfg.appName != null) {
          "--app-name" = cfg.appName;
        };
    };
  };
}
