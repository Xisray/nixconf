{
  flake.homeModules.ocr =
    { pkgs, lib, ... }:
    let
      ocr = pkgs.writeShellApplication {
        name = "ocr";
        runtimeInputs = with pkgs; [
          grim
          slurp
          tesseract
          wl-clipboard
          libnotify
        ];
        text = ''
          set -euo pipefail

          geometry=$(slurp -b '#000000A0' -c '#FFFFFFCC' -w 2) || exit 0          # Escape = ничего не делать

          text=$(grim -g "$geometry" - | tesseract stdin stdout -l rus+eng 2>/dev/null || true)

          if [ -n "''${text// }" ]; then       # проверяем, что не только пробелы
            printf '%s' "$text" | wl-copy
            notify-send -u low "OCR" "Текст скопирован"
          else
            notify-send -u low "OCR" "Ничего не распознано"
          fi
        '';
      };
    in
    {
      preferences.binds."Mod+Shift+X".action = [ (lib.getExe ocr) ];
    };
}
