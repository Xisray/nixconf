{
  flake.nixosModules.preferences = {lib, ...}: {
    options.preferences.mouse = with lib; {
      accelProfile = mkOption {
        type = types.nullOr (
          types.enum [
            "adaptive"
            "flat"
          ]
        );
        default = null;
        description = "Mouse acceleration profile (null = default)";
      };
      accelSpeed = mkOption {
        type = types.nullOr (types.float);
        default = null;
        description = "Mouse acceleration speed from -1.0 to 1.0 (null = default)";
      };
      naturalScroll = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Invert mouse scroll direction";
      };
      scrollFactor = mkOption {
        type = types.nullOr types.float;
        default = null;
        description = "Scale mouse scroll speed";
      };
    };
  };
}
