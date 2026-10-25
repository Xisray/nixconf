{self, ...}: {
  flake.nixosModules.telegram = {pkgs, ...}: let
    dataDir = ".local/share/AyuGramDesktop";
    package = pkgs.ayugram-desktop;
    telegram = self.wrappers.telegram.wrap {
      inherit pkgs package;
      theme = "$HOME/.config/telegram-desktop/themes/nix.tdesktop-theme";
      tdata = "${dataDir}/tdata";
    };
  in {
    user.packages = [telegram];
    preferences.persistence.data.directories = [dataDir];
  };
}
