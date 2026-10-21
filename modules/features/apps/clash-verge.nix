{
  flake.nixosModules.clash-verge = {
    config,
    pkgs,
    ...
  }: {
    programs.clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = false;
    };
    fpatcher.clash-verge = {
      user = config.preferences.user.name;
      path = ".local/share/io.github.clash-verge-rev.clash-verge-rev/verge.yaml";
      format = "yaml";
      content = {
        auto_check_update = false;
      };
      before = ''
        was_running=0
        if pgrep -f '^clash-verge$' >/dev/null; then
          was_running=1
          pkill -f '^clash-verge$' || true
          # ждём завершения (до ~10 с): при выходе приложение перезаписывает verge.yaml
          for _ in $(seq 50); do
            pgrep -f '^clash-verge$' >/dev/null || break
            sleep 0.2
          done
        fi
      '';
      after = ''
        if [ "$was_running" = 1 ]; then
          uid=$(id -u)
          export XDG_RUNTIME_DIR=/run/user/$uid
          export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus
          export WAYLAND_DISPLAY=wayland-1
          ${pkgs.util-linux}/bin/setsid -f ${pkgs.clash-verge-rev}/bin/clash-verge >/dev/null 2>&1 || true
        fi
      '';
    };
    preferences = {
      proxy = {
        https = "http://127.0.0.1:7897";
        http = "http://127.0.0.1:7897";
        all = "socks5h://127.0.0.1:7897";
      };
      persistence = {
        data.directories = [
          ".local/share/io.github.clash-verge-rev.clash-verge-rev"
        ];
        cache.directories = [
          ".cache/io.github.clash-verge-rev.clash-verge-rev"
        ];
      };
    };
  };
}
