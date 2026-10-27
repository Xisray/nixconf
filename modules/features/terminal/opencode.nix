{
  flake.nixosModules.opencode = {
    config,
    lib,
    inputs,
    pkgs,
    ...
  }: {
    appearance.targets.opencode.enable = true;
    shell.packages.opencode = lib.mkIf (config.preferences.proxy != null) (
      inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.opencode;
        env = config.preferences.proxy.env;
      }
    );
  };
}
