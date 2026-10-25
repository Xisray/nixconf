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
    preferences.persistence = {
      data.directories = [
        ".local/share/devenv"
      ];
      cache.directories = [
        ".cache/nix"
      ];
    };
  };
}
