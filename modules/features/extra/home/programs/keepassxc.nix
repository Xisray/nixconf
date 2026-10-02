{
  flake.hjemExtraModules.home = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.programs.keepassxc = {
      enable = lib.mkEnableOption "keepassxc";
      package = lib.mkPackageOption pkgs "keepassxc" {nullable = true;};
      systemd.enable = lib.mkEnableOption "A systemd user service for keepassxc";
    };
    config = let
      cfg = config.programs.keepassxc;
    in
      lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = !cfg.systemd.enable || cfg.package != null;
            message = "programs.keepassxc.package cannot be null when programs.keepassxc.systemd.enable is true";
          }
        ];
        packages = lib.optional (cfg.package != null) cfg.package;
        systemd.services.keepassxc = lib.mkIf cfg.systemd.enable {
          enable = true;
          description = "KeePassXC";
          wantedBy = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          after = ["graphical-session.target"];
          serviceConfig = {
            ExecStart = lib.getExe cfg.package;
            Restart = "on-failure";
          };
        };
      };
  };
}
