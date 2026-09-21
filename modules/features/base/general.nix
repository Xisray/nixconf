{ self, ... }: {
  flake.nixosModules.general = { config, ... }: {
    imports = [
      self.nixosModules.impermanence
      self.nixosModules.nix
      self.nixosModules.boot
      self.nixosModules.audio
      self.nixosModules.fonts
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
      # shell = pkgs.${config.preferences.shell};

      hashedPasswordFile = "/persist/passwd";
    };
    preferences.persistance.data.directories = [
      "nixconf"
      "Downloads"
      "Documents"
      "Projects"
      "Pictures"
      ".ssh"
    ];
  };
}
