{
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.ocr = pkgs.writeShellApplication {
      name = "ocr";
      runtimeInputs = with pkgs; [
        grim
        (self'.packages.slurp or slurp)
        (tesseract.override {
          enableLanguages = ["rus" "eng"];
        })
        wl-clipboard
        libnotify
      ];
      text = ''
        set -euo pipefail
        app="''${OCR_APP_NAME:-}"
        lang="''${SSHOT_OCR_LANG:-rus+eng}"
        while [ $# -gt 0 ]; do
          case "$1" in
            -a|--app-name) app="''${2:?need app name}"; shift 2 ;;
            -l|--lang) lang="''${2:?need language code(s)}"; shift 2 ;;
            *) echo "sshot: unknown argument: $1" >&2; exit 2 ;;
          esac
        done

        notify_args=(-u low)
        if [ -n "$app" ]; then
          notify_args+=(-a "$app")
        fi

        geometry=$(slurp) || exit 0
        [ -z "$geometry" ] && exit 0
        text=$(grim -g "$geometry" - | tesseract stdin stdout -l "$lang" 2>/dev/null || true)
        clean_text="$(printf '%s' "$text" | tr -d '[:space:]')"

        if [ -n "$clean_text" ]; then
          printf '%s' "$text" | wl-copy
          notify-send "''${notify_args[@]}" "Text Grab" "Text copied to clipboard"
        else
          notify-send "''${notify_args[@]}" "Text Grab" "No text recognized"
        fi
      '';
    };
  };
}
