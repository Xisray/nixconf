{
  flake.wrappers.hyprpicker = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.modules.default];
    package = pkgs.writeShellApplication {
      name = "hyprpicker";
      runtimeInputs = with pkgs; [hyprpicker wl-clipboard libnotify imagemagick];
      text = ''
        color="$(hyprpicker "$@")" || exit 0
        [ -n "$color" ] || exit 0
        
        swatch="$(mktemp --suffix=.png -p "''${XDG_RUNTIME_DIR:-/tmp}" hyprpicker-XXXXXX)"
        trap 'rm -f "$swatch"' EXIT

        magick -size 64x64 "xc:$color" "$swatch"
        notify-send -i "$swatch" "Color picker" "Selected color: $color"
      '';
    };
  };
}
