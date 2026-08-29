{ ... }: {
  flake.nixosModules.keepassxc = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.keepassxc ];

  };
}
