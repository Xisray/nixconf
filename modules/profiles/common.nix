{self, ...}: {
  flake.nixosModules.common = {pkgs, ...}: {
    imports = [
      self.nixosModules.preferences
      self.nixosModules.boot
      self.nixosModules.network
      self.nixosModules.audio
      self.nixosModules.locale
      self.nixosModules.nix
      self.nixosModules.impermanence
      self.nixosModules.sops
      self.nixosModules.homefs
      self.nixosModules.xdg
      self.nixosModules.gtk
      self.nixosModules.qt
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.usb
      self.nixosModules.qbittorrent
      self.nixosModules.syncthing
      self.nixosModules.firefox
      self.nixosModules.clash-verge
      self.nixosModules.keepassxc
      self.nixosModules.kitty
      self.nixosModules.shell
      self.nixosModules.telegram
      self.nixosModules.utils
      self.nixosModules.voxtype
      self.nixosModules.podman
      self.nixosModules.libvirtd
      self.nixosModules.libreoffice
      self.nixosModules.fpatcher
      self.nixosModules.qview
    ];
    nixpkgs.config.allowUnfree = true;
    appearance.fonts.packages = [pkgs.corefonts];
    preferences.persistence.data.directories = [
      "Downloads"
      "Documents"
      "Projects"
      "Pictures"
      ".ssh"
    ];
  };
}
