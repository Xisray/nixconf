{ lib, ... }: {
  options.flake.selectedApps = {
    shell = lib.mkOption {
      type = lib.types.package;
      description = "Selected shell package";
    };
    terminal = lib.mkOption {
      type = lib.types.package;
      description = "Selected terminal package";
    };
  };
}
