{
  flake.wrappers.udiskie = {
    wlib,
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [wlib.modules.default wlib.modules.systemd];
    options.settings = lib.mkOption {
      type = wlib.types.structuredValueWith {typeName = "YAML";};
      default = null;
    };

    config = {
      package = pkgs.udiskie;
      settings.program_options = {
        tray = lib.mkDefault "auto";
        notify = lib.mkDefault true;
        automount = lib.mkDefault true;
      };
      constructFiles.udiskie-config = {
        relPath = "share/udiskie/config.yml";
        content = builtins.toJSON config.settings;
      };
      flags."-c" = config.constructFiles.udiskie-config.path;

      systemd.user.service.udiskie = {
        Unit = {
          Description = "UDiskie mount daemon";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          ExecStart = "${placeholder "out"}/bin/udiskie";
          Environment = [
            "PATH=%h/.nix-profile/bin:/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin"
            "XDG_DATA_DIRS=%h/.local/share:%h/.nix-profile/share:/etc/profiles/per-user/%u/share:/run/current-system/sw/share"
          ];
          Restart = "on-failure";
        };
      };
    };
  };
}
