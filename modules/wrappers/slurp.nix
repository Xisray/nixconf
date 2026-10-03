{
  perSystem = {pkgs, ...}: {
    packages.slurp = pkgs.writeShellApplication {
      name = "slurp";
      runtimeInputs = with pkgs; [
        slurp
        jq
      ];
      text = ''
        cfg="''${SLURP_CONFIG:-''${XDG_CONFIG_HOME:-$HOME/.config}/slurp/config.json}"
        get() {
          local v=""
          if [ -r "$cfg" ]; then
            v=$(jq -r --arg k "$1" '.[$k] // empty | tostring' "$cfg" 2>/dev/null || true)
          fi
          printf '%s' "''${v:-$2}"
        }
        color() {
          local v
          v=$(get "$1" "$2")
          if [[ $v =~ ^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$ ]]; then
            printf '%s' "$v"
          else
            printf '%s' "$2"
          fi
        }

        border_color=$(color borderColor '#89b4faff')
        selection_color=$(color selectionColor '#89b4fa33')
        dim_color=$(color dimColor '#00000066')
        box_color=$(color boxColor '#89b4fa22')
        border_width=$(get borderWidth 2)
        [[ $border_width =~ ^[0-9]+$ ]] || border_width=2

        exec slurp -d -b "$dim_color" -c "$border_color" -s "$selection_color" -B "$box_color" -w "$border_width" "$@"
      '';
    };
  };
}
