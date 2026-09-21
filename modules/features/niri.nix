{
  self,
  ...
}:
{
  flake.nixosModules.niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };

      home.files.".config/niri/config.kdl".text =
        let
          cfg = config.preferences;
          blur =
            if cfg.ui.blur.enable then
              ''
                blur {
                  passes 2
                  offset 3.0
                  noise 0.03
                  saturation 1.0
                }
              ''
            else
              "";
          mouse = ''
            input {
              mouse {
                ${lib.optionalString (
                  cfg.mouse.accelProfile != null
                ) ''accel-profile "${cfg.mouse.accelProfile}"''}
                ${lib.optionalString (
                  cfg.mouse.accelSpeed != null
                ) "accel-speed ${toString cfg.mouse.accelSpeed}"}
                ${lib.optionalString (
                  cfg.mouse.scrollFactor != null
                ) "scroll-factor ${toString cfg.mouse.scrollFactor}"}
                ${lib.optionalString cfg.mouse.naturalScroll "natural-scroll"}
              }
            }
          '';

        in
        ''
          ${blur}
          ${mouse}
        '';
    };
}
