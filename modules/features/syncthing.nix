{ ... }: {
  flake.nixosModules.syncthing = {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiPasswordFile = "/persist/passwd";
    };
    # networking.firewall.allowedTCPPorts = [ 8384 ];
  };
}
