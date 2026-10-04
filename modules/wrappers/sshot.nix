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
        while [ $# -gt 0 ]; do
          case "$1" in
            -a|--app-name) app="''${2:?need app name}"; shift 2 ;;
            *) echo "sshot: unknown argument: $1" >&2; exit 2 ;;
          esac
        done
        if [ "''${SSHOT_DIRECTORY:-}" = "null" ]; then
          file="$(mktemp --suffix=.png)"
          trap 'rm -f "$file"' EXIT
        else
          fmt="''${SSHOT_FORMAT:-%Y-%m-%d_%H-%M-%S}"
          dir="''${SSHOT_DIRECTORY:-$HOME/Pictures/Screenshots}"
          dir="''${dir/#\~/$HOME}"
          mkdir -p "$dir"
          file="$dir/$(date +"$fmt").png"
        fi

        grim -g "$(slurp)" "$file" || exit 0
        wl-copy < "$file"
        notify-send -i "$file" -a "$app" "Screenshot captured" "You can paste the image from the clipboard"
      '';
    };
  };
}
