{ self, ... }: {
  flake.nixosModules.yazi = { config, pkgs, lib, ... }: {
    environment.systemPackages = [
      (self.packages.${pkgs.stdenv.hostPlatform.system}.yazi or pkgs.yazi)
    ];
    home.files.".config/yazi/theme.toml" = {
      generator = (pkgs.formats.toml { }).generate "theme.toml";
      value =
      let
        block = { open = "█"; close = "█"; };
      in
        lib.optionalAttrs config.programs.noctalia.enable {
          flavor.dark = "noctalia";
          flavor.light = "noctalia";
        }
        // lib.optionalAttrs (config.preferences.ui.corner.radius == 0) {
          status.sep_left = block;
          status.sep_right = block;
          indicator.padding = block;
        };
    };
  };
}
