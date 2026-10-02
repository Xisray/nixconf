{
  flake.nixosModules.gtk = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.systemPackages = [
      pkgs.adw-gtk3
      pkgs.papirus-icon-theme
    ];
    programs.dconf.enable = true;
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    home.xdg.portal.config.common.default = "gtk";
    home.gtk.settings = let
      fonts = config.fonts.fontconfig.defaultFonts.sansSerif;
    in
      {
        gtk-theme-name = "adw-gtk3";
        gtk-icon-theme-name = "Papirus-Dark";
      }
      // lib.optionalAttrs (fonts != []) {
        gtk-font-name = "${builtins.head fonts} 12";
      };
  };
}
