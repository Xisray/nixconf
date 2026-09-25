{
  flake.wrappers.keepassxc = { pkgs, wlib, lib, config, ... }: {
    imports = [ wlib.modules.default ];
    package = pkgs.keepassxc;
    constructFiles.keepassxc-ini = {
      relPath = "share/keepassxc-config/keepassxc.ini";
      content = lib.generators.toINI { } {
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
    flags."--config" = config.constructFiles.keepassxc-ini.path;
  };
}
