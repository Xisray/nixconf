{
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.sshot = pkgs.writeShellApplication {
      name = "sshot";
      runtimeInputs = with pkgs; [
        (self'.packages.slurp or slurp)
        grim
        jq
        wl-clipboard
        libnotify
        coreutils
      ];
      text = ''
        app="''${SSHOT_APP_NAME:--sshot}"
        geom=""
        output=""
        while [ $# -gt 0 ]; do
          case "$1" in
            -g|--geometry) geom="''${2:?need geometry}"; shift 2 ;;
            -o|--output) output="''${2:?need monitor name}"; shift 2 ;;
            -a|--app-name) app="''${2:?need app name}"; shift 2 ;;
            *) echo "sshot: unknown argument: $1" >&2; exit 2 ;;
          esac
        done

        dir="''${$SSHOT_DIRECTORY:-$HOME/Pictures/Screenshots}"
        dir="''${dir/#\~/$HOME}"
        fmt="''${SSHOT_FORMAT:-%Y-%m-%d_%H-%M-%S}"

        mkdir -p "$dir"
        file="$dir/$(date +"$fmt").png"

        fail() {
          notify-send -u critical -a "$app" "Screenshot" "Failed to take the screenshot"
          exit 1
        }

        if [ -n "$output" ]; then
          grim -o "$output" "$file" || fail
        else
          if [ -z "$geom" ]; then
            regions=""
            if [ ! -t 0 ]; then regions=$(cat); fi
            if [ -n "$regions" ]; then regions="$regions"$'\n'; fi
            geom=$(printf '%s' "$regions" | slurp) || exit 0
          fi
          grim -g "$geom" "$file" || fail
        fi

        wl-copy < "$file"
        notify-send -i "$file" -a "$app" "Screenshot saved" "$file"$'\n'"Copied to clipboard"
      '';
    };
  };
}
