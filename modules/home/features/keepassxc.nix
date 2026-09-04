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
  };
}
