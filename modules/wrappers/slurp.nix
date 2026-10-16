{
  flake.wrappers.slurp = {
    lib,
    pkgs,
    wlib,
    config,
    ...
  }: {
    imports = [wlib.modules.default];
    options.settings = {
      width = lib.mkOption {
        type = lib.types.ints.positive;
        default = 2;
      };
      colors = {
        border = lib.mkOption {
          type = lib.types.str;
          default = "#ffffffff";
        };
        selection = lib.mkOption {
          type = lib.types.str;
          default = "#00000000";
        };
        dim = lib.mkOption {
          type = lib.types.str;
          default = "#000000A0";
        };
        box = lib.mkOption {
          type = lib.types.str;
          default = "#89b4fa22";
        };
      };
    };
    config = let
      cfg = config.settings;
      colors = cfg.colors;
    in {
      package = pkgs.slurp;
      flags = {
        "-d" = true;
        "-b" = colors.dim;
        "-c" = colors.border;
        "-s" = colors.selection;
        "-B" = colors.box;
        "-w" = toString cfg.width;
      };
    };
  };
}
