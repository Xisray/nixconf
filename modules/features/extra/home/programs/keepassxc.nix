{
  flake.hjemExtraModules.home =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      options.programs.keepassxc = {
        enable = lib.mkEnableOption "keepassxc";
        package = lib.mkPackageOption pkgs "keepassxc";
        systemd.enable = lib.mkEnableOption "A systemd user service for noctalia";
      };
      config =
        let
          cfg = config.programs.keepassxc;
        in
        lib.mkIf cfg.enable {
          packages = lib.optional (cfg.package != null) cfg.package;
          systemd.services.keepassxc = lib.mkIf cfg.systemd.enable {
            enable = true;
            description = "KeePassXC";
            wantedBy = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = lib.getExe cfg.package;
              Restart = "on-failure";
            };
          };
        };
    };
}
