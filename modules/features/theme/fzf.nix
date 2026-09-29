{
  flake.nixosModules.theme = {
    config,
    lib,
    ...
  }: let
    cfg = config.preferences.theme;
  in {
    preferences.theme.targets.fzf = {
      enable = lib.mkDefault false;
    };
    home.xdg.config.files = lib.mkIf cfg.targets.fzf.enable {
      "fish/config.fish" = lib.mkIf config.programs.fish.enable {
        generator = lib.mkDefault lib.concatLines;
        value = [
          "source ~/.config/fzf/themes/${cfg.provider}.fish"
        ];
      };
    };
  };
}
