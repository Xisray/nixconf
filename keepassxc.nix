{ ... }: {
  flake.nixosModules.keepassxc =
    { pkgs, config, ... }:
    let
      user = config.preferences.user.name;
      iniFormat = pkgs.formats.ini { };
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
      settingsFile = iniFormat.generate "keepassxc.ini" settings;
    in
    {
      environment.systemPackages = [ pkgs.keepassxc ];

      systemd.user.tmpfiles.users.${user}.rules = [
        "d %h/.config/keepassxc 0755 ${user} users -"
        "L+ %h/.config/keepassxc/keepassxc.ini - - - - ${settingsFile}"
      ];

      preferences.persistance.data.directories = [
        ".config/keepassxc"
      ];

      preferences.persistance.cache.directories = [
        ".cache/keepassxc"
      ];
    };
}
