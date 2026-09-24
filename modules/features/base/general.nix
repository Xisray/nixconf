{ self, ... }: {
  flake.nixosModules.general = { config, ... }: {
    imports = [
      self.nixosModules.impermanence
      self.nixosModules.nix
      self.nixosModules.boot
      self.nixosModules.audio
      self.nixosModules.fonts
      self.nixosModules.hjem
      self.nixosModules.shell
    ];
    networking.networkmanager.enable = true;
    time.timeZone = "Asia/Yekaterinburg";

    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
      ];
      hashedPasswordFile = "/persist/passwd";
    };
    preferences.persistence.data.directories = [
      "nixconf"
      "Downloads"
      "Documents"
      "Projects"
      "Pictures"
      ".ssh"
    ];
  };
}
