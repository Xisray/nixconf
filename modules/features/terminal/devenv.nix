{
  flake.shellModules.devenv = {
    module = {
      lib,
      preferences,
      pkgs,
      wlib,
      ...
    }: {
      packages.devenv = lib.mkIf (preferences.proxy != null) (wlib.wrapPackage {
        inherit pkgs;
        package = pkgs.devenv;
        env = preferences.proxy.env;
      });
    };
    nixos = {
      preferences.persistence = {
        data.directories = [
          ".local/share/devenv"
        ];
        cache.directories = [
          ".cache/nix"
        ];
      };
    };
  };
}
