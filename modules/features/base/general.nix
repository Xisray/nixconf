{
  flake.nixosModules.general = { config, ... }: {
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
