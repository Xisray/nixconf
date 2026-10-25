{
  flake.nixosModules.appearance = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.bat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bat;
      };
    };
    config = lib.mkIf (cfg.hasScheme && cfg.targets.bat.enable) (let
      theme = cfg.colors {src = ./bat.tmTheme.mustache;};
    in {
      homefs.directories.".config/bat".files = {
        "config".text = "--theme=nix";
        "themes/nix.tmTheme" = theme;
      };
      systemd.user.services.bat-cache-build = {
        description = "Rebuild bat cache after theme change";
        wantedBy = ["default.target"];
        restartTriggers = [theme];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${lib.getExe cfg.targets.bat.package} cache --build";
        };
      };
    });
  };
}
