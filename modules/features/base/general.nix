{self, ...}: {
  flake.nixosModules.general = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.nix
      self.nixosModules.boot
      self.nixosModules.usb
      self.nixosModules.audio
      self.nixosModules.fonts
      self.nixosModules.preferences
      self.nixosModules.gtk
      self.nixosModules.qt
      self.nixosModules.shell
    ];
    networking.networkmanager.enable = true;
    time.timeZone = "Asia/Yekaterinburg";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
    home.packages = [
      pkgs.ayugram-desktop
      pkgs.libreoffice
    ];

    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
      ];
      hashedPasswordFile = "/persist/passwd";
    };

    xdg = {
      portal.enable = true;
      mime.enable = true;
    };

    preferences.persistence.data.directories = [
      "Downloads"
      "Documents"
      "Projects"
      "Pictures"
      ".ssh"
    ];
  };
}
