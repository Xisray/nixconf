{
  flake.nixosModules.appearance = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.lazygit.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.lazygit.enable) {
      homefs.files.".config/lazygit/config.yml" = (pkgs.foramts.yaml {}).generate "lazygit-config.yml" lib.mkMerge [
        {
          gui.border =
            if (cfg.rounding == 0)
            then "single"
            else "rounded";
        }
        (lib.mkIf (cfg.hasScheme) {
          gui.theme = with cfg.colors.withHashtag; {
            activeBorderColor = [
              base0D
              "bold"
            ];
            inactiveBorderColor = [base03];
            searchingActiveBorderColor = [base09];
            optionsTextColor = [base0D];
            selectedLineBgColor = [base02];
            inactiveViewSelectedLineBgColor = [base04];
            cherryPickedCommitFgColor = [base0D];
            cherryPickedCommitBgColor = [base03];
            markedBaseCommitFgColor = [base0D];
            markedBaseCommitBgColor = [base0A];
            unstagedChangesColor = [base08];
            defaultFgColor = [base05];
            authorColors."*" = base07;
          };
        })
      ];
    };
  };
}
