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
      self.nixosModules.xdg
      self.nixosModules.niri
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
