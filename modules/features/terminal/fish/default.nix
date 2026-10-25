{
  flake.nixosModules.shell = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf (config.programs.fish.enable && config.appearance.scheme != null) {
      homefs.files.".config/fish/conf.d/theme.fish" = config.appearance.colors {src = ./theme.fish.mustache;};
    };
  };
}
