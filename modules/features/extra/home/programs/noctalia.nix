{
  flake.hjemExtraModules.home = {
    lib,
    pkgs,
    config,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};
  in {
    options.programs.noctalia = {
      enable = lib.mkEnableOption "Noctalia Wayland desktop shell";
      package = lib.mkPackageOption pkgs "noctalia";
      systemd.enable = lib.mkEnableOption "A systemd user service for noctalia";
      settings = lib.mkOption {
        type = with lib.types; oneof [tomlFormat.type str path];
        default = {};
      };
    };
    config = let
      cfg = config.programs.noctalia;
    in
      lib.mkIf cfg.enable {
        packages = lib.optional (cfg.package != null) cfg.package;
        systemd.services.noctalia = lib.mkIf cfg.systemd.enable {
          enable = true;
          description = "Noctalia Wayland desktop shell";
          documentation = "https://docs.noctalia.dev/v5/";
          wantedBy = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          after = ["graphical-session.target"];
          serviceConfig = {
            ExecStart = lib.getExe cfg.package;
            Restart = "on-failure";
          };
        };
        xdg.config.files."noctalia/config.toml" = lib.mkIf (cfg.settings != {}) (
          if lib.isString cfg.settings
          then {text = cfg.settings;}
          else if builtins.isPath cfg.settings || lib.isStorePath cfg.settings
          then {source = cfg.settings;}
          else {source = tomlFormat "config.toml" cfg.settings;}
        );
      };
  };
}
