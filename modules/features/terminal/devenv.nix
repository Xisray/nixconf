{self, ...}: {
  flake.shellModules.devenv = {
    lib,
    appearance,
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
}
