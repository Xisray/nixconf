{self,...}:{
  flake.nixosModules.common = {
    imports = [
      self.nixosModules.preferences
      self.nixosModules.boot
      self.nixosModules.network
      self.nixosModules.audio
      self.nixosModules.locale
      self.nixosModules.nix
      self.nixosModules.impermanence
      self.nixosModules.sops
      self.nixosModules.xdg
      self.nixosModules.gtk
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.qbittorrent
      self.nixosModules.syncthing
      self.nixosModules.firefox
      self.nixosModules.clash-verge
      self.nixosModules.keepassxc
      self.nixosModules.kitty
      self.nixosModules.shell
    ];
    preferences.persistence.data.directories = [
      "Downloads"
      "Documents"
      "Projects"
      "Pictures"
      ".ssh"
    ];
  };
}
