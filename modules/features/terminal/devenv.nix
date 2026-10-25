{
  flake.nixosModules.devenv = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: {
    shell.packages.devenv = lib.mkIf (config.preferences.proxy != null) (
      inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.devenv;
        env = config.preferences.proxy.env;
      }
    );
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
    preferences.persistence = {
      data.directories = [
        ".local/share/devenv"
        ".local/share/direnv"
      ];
      cache.directories = [
        ".cache/nix"
      ];
    };
  };
  perSystem = {...}: {
    devenv.shells = {
      nix = {
        languages.nix.enable = true;
        git-hooks.hooks.alejandra.enable = true;
      };
    };
  };
}
