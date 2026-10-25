{
  flake.nixosModules.appearance = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.telegram = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      themePath = lib.mkOption {
        type = lib.types.str;
        default = ".config/telegram-desktop/themes/nix.tdesktop-theme";
      };
    };
    config = lib.mkIf (cfg.hasScheme && cfg.targets.telegram.enable) {
      homefs.files.${cfg.targets.telegram.themePath} = let
        theme = cfg.colors {src = ./telegram.tdesktop-theme.mustache;};
      in
        pkgs.runCommand "telegram.tdesktop-theme" {nativeBuildInputs = [pkgs.zip pkgs.imagemagick];} ''
          mkdir t && cd t
          cp ${theme} colors.tdesktop-theme
          magick -size 64x64 xc:'#${cfg.colors.base00}' background.png
          zip -X "$out" colors.tdesktop-theme background.png
        '';
    };
  };
}
