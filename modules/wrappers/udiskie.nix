{
  flake.wrappers.udiskie = {
    wlib,
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [wlib.modules.default];
    options.settings = lib.mkOption {
      type = wlib.types.structuredValueWith {typeName = "YAML";};
      default = null;
    };

    config = {
      package = pkgs.udiskie;
      settings.program_options = {
        tray = lib.mkDefault "auto";
        notify = lib.mkDefault true;
        automount = lib.mkDefault true;
      };
      constructFiles.udiskie-config = {
        relPath = "share/udiskie/config.yml";
        content = builtins.toJSON config.settings;
      };
      flags."-c" = config.constructFiles.udiskie-config.path;
    };
  };
}
