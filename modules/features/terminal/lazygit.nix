{
  flake.nixosModules.lazygit = {
    config,
    lib,
    pkgs,
    ...
  }: let
    style = config.appearance;
    hasScheme = style.scheme != null;
    flat = style.rounding == 0;
    toYAML = pkgs.formats.yaml {};
  in {
    homefs.files.".config/lazygit/config.yml" = {
      value = {
        gui = lib.mkIf (flat || hasScheme) {
          theme = lib.mkIf hasScheme (
            with style.colors.withHashtag; {
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
            }
          );
          border = lib.mkIf flat "single";
        };
      };
      generator = toYAML.generate "config.yml";
    };
    preferences.persistence.data.directories = [
      ".local/share/lazygit"
    ];
  };
}
