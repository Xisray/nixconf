{self, ...}: {
  flake.shellModules.lazygit = {
    module = {
      lib,
      appearance,
      pkgs,
      ...
    }: let
      lazygit = self.wrappers.lazygit or null;
    in {
      packages.lazygit = lib.mkIf (lazygit != null && appearance.scheme != null) (lazygit.wrap {
        inherit pkgs;
        settings.gui = with appearance.colors.withHashtag; {
          theme = {
            activeBorderColor = [base0D "bold"];
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
          border = lib.mkIf (appearance.rounding == 0) "single";
        };
      });
    };
    nixos = {
      preferences.persistence.data.directories = [
        ".local/share/lazygit"
      ];
    };
  };
}
