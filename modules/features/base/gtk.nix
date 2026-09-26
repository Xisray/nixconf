{
  flake.nixosModules.gtk = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.adw-gtk3
    ];
    programs.dconf.enable = true;
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    home.xdg.portal.config.common.default = "gtk";
  };
}
