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
      config.common.default = [ "gtk" ];
    };
  };
}
