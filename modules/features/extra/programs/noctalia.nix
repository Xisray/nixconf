{
  flake.hjemExtraModules.programs = { lib, pkgs, ... }: {
    options.programs.noctalia = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.noctalia;
      };
      settings = 

    };

  };
}
