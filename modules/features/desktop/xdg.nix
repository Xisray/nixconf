{
  flake.nixosModules.xdg = {
    xdg = {
      portal.enable = true;
      mime.enable = true;
    };
  };
}
