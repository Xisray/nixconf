{
  flake.homeModules.keepassxc = {
    programs.keepassxc = {
      enable = true;
      settings = {
        Browser = {
          AllowExpiredCredentials = true;
          Enabled = true;
        };
        GUI = {
          ColorPasswords = true;
          MinimizeOnClose = true;
          MinimizeToTray = true;
          MinimizeOnStartup = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
          ApplicationTheme = "classic";
        };
        Security = {
          HideTotpPreviewPanel = true;
          Security_HideNotes = true;
        };
      };
    };
    preferences.autostart = [ "keepassxc" ];

    preferences.persistance.cache.directories = [
      ".cache/keepassxc"
    ];
    preferences.windowRules = [
      {
        matches = [
          {
            app-id = "^KeePassXC$";
            title = "^Unlock Database - KeePassXC$";
          }
        ];
        open-floating = true;
      }
    ];
  };
}
