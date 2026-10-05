{
  flake.nixosModules.preferences = {lib, ...}: {
    options.preferences = with lib; {
      binds = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            action = mkOption {
              type = with types; either str (listOf str);
            };
            shell = mkEnableOption "Shell action";
            allowLocked = mkOption {
              type = with types; nullOr bool;
              default = null;
            };
          };
        });
        default = {};
      };
    };
  };
}
