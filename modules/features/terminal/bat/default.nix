{
  flake.nixosModules.bat = {
    lib,
    config,
    pkgs,
    ...
  }: let
    hasScheme = config.appearance.scheme != null;
  in {
    config = lib.mkMerge [
      {
        preferences.persistence.cache.directories = [
          ".cache/bat"
        ];
      }
      (lib.mkIf hasScheme (
        let
          theme = config.appearance.colors {src = ./bat.tmTheme.mustache;};
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
              ExecStart = "${pkgs.bat}/bin/bat cache --build";
            };
          };
        }
      ))
    ];
  };
}
