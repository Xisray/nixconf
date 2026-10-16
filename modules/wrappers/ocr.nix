{self, ...}: {
  flake.wrappers.ocr = {
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
      languages = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["rus" "eng"];
        description = "Языки tesseract: ставятся в пакет и передаются в --lang";
      };
      appName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Имя приложения в уведомлениях; null: не задавать";
      };
    };

    config = let
      cfg = config.settings;
    in {
      package = pkgs.writeShellApplication {
        name = "ocr";
        runtimeInputs =
          [
            cfg.slurp
            (pkgs.tesseract.override {enableLanguages = cfg.languages;})
          ]
          ++ (with pkgs; [grim wl-clipboard libnotify coreutils]);
        text = ''
          app=""
          lang="eng"

          while [ $# -gt 0 ]; do
            case "$1" in
              -a|--app-name) app="''${2:?need app name}"; shift 2 ;;
              -l|--lang)     lang="''${2:?need language code(s)}"; shift 2 ;;
              *) echo "ocr: unknown argument: $1" >&2; exit 2 ;;
            esac
          done

          notify_args=(-u low)
          if [ -n "$app" ]; then
            notify_args+=(-a "$app")
          fi

          geometry="$(slurp)" || exit 0
          [ -z "$geometry" ] && exit 0

          text="$(grim -g "$geometry" - | tesseract stdin stdout -l "$lang" 2>/dev/null || true)"
          clean_text="$(printf '%s' "$text" | tr -d '[:space:]')"

          if [ -n "$clean_text" ]; then
            printf '%s' "$text" | wl-copy
            notify-send "''${notify_args[@]}" "Text Grab" "Text copied to clipboard"
          else
            notify-send "''${notify_args[@]}" "Text Grab" "No text recognized"
          fi
        '';
      };

      flags =
        {
          "--lang" = lib.concatStringsSep "+" cfg.languages;
        }
        // lib.optionalAttrs (cfg.appName != null) {
          "--app-name" = cfg.appName;
        };
    };
  };
}
