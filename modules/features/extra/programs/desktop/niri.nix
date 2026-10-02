{
  flake.hjemExtraModules.programs = { lib, ... }: {
    options.desktop.niri = {
      settings = lib.mkOption {
        type = lib.types.submodule {
          options = {
            # binds;
            # outputs;
            # windowsRules;
            # layersRules;
            # extraConfig;
            # spawnAtStartup;
            # spawnShAtStartup;
            # workspaces;
            # layout;
          };
        };
        default = { };
      };

    };

  };
}
