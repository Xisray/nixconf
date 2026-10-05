{self,...}:{
  flake.nixosModules.laptop = {
    imports = [
      self.nixosModules.common
      self.nixosModules.bluetooth
      self.nixosModules.power
    ];
  };
}
