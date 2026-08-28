{ self, ... }: {
  flake.nixosModules.general = { pkgs, config, ... }: {
    imports = [
      self.nixosModules.audio
      self.nixosModules.fonts
    ];
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    networking = {
      hostName = config.preferences.hostName;
      networkmanager.enable = true;
    };
    time.timeZone = "Asia/Yekaterinburg";

    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;

      hashedPasswordFile = "/persist/passwd";
      initialPassword = "12345";
    };
    preferences.persistance.data.directories = [
      "nixconf"

      "Downloads"
      "Documents"
      "Projects"

      ".ssh"
    ];
  };
}
