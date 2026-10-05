{
  flake.nixosModules.preferences = {lib, ...}: {
    options.preferences.wm.rules = with lib; {
      windows = mkOption {
        type = types.listOf types.attrs;
        default = [];
      };
      layers = mkOption {
        type = types.listOf types.attrs;
        default = [];
      };
    };
  };
}
