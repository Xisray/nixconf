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
        tesseract
        wl-clipboard
        libnotify
      ];
      text = ''
        set -euo pipefail
        geometry=slurp || exit 0
        text=$(grim -g "$geometry" - | tesseract stdin stdout -l rus+eng 2>/dev/null || true)
        if [ -n "''${text// }" ]; then
          printf '%s' "$text" | wl-copy
          notify-send -u low "OCR" "Текст скопирован"
        else
          notify-send -u low "OCR" "Ничего не распознано"
        fi
      '';
    };
  };
}
