{ self, ... }: {
  flake.homeModules.general = { pkgs, lib, ... }: {
    imports = [
      self.homeModules.ocr
      self.homeModules.colorPicker
      self.homeModules.sops
    ];
    home.packages = with pkgs; [
      wl-clipboard
      devenv
      libreoffice-qt
    ];
    services.udiskie = {
      enable = true;
    };
    preferences.binds =
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
  };
}
