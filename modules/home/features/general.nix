{ self, ... }: {
  flake.homeModules.general = { pkgs, lib, ... }: {
    imports = [
      self.homeModules.ocr
      self.homeModules.colorPicker
      self.homeModules.sops
      self.homeModules.yazi
    ];
    home.packages = with pkgs; [
      wl-clipboard
      libreoffice-qt
      ayugram-desktop
    ];
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
    };
    xdg.mimeApps = {
      enable = true;
    };
    # home.sessionVariables = {
    #   GTK_USE_PORTAL = "1";
    #   GDK_DEBUG = "portals";
    # };
    services.udiskie.enable = true;
    preferences = {
      binds =
        let
          playerCtl = lib.getExe pkgs.playerctl;
        in
        {
          "XF86AudioPlay".action = [
            playerCtl
            "play"
          ];
          "XF86AudioPause".action = [
            playerCtl
            "pause"
          ];
          "XF86AudioNext".action = [
            playerCtl
            "next"
          ];
          "XF86AudioPrev".action = [
            playerCtl
            "previous"
          ];
          "Mod+Shift+Space".action = [
            playerCtl
            "play-pause"
          ];
          "Mod+Shift+period".action = [
            playerCtl
            "next"
          ];
          "Mod+Shift+comma".action = [
            playerCtl
            "previous"
          ];
        };
      persistance.data.directories = [
        ".local/share/AyuGramDesktop"
      ];
    };
  };
}
