{ self, ... }: {
  flake.homeModules.general = { pkgs, ... }: {
    imports = [
      self.homeModules.ocr
      self.homeModules.colorPicker
      self.homeModules.sops
    ];
    home.packages = with pkgs; [
      wl-clipboard
      devenv
    ];
    services.udiskie = {
      enable = true;
    };
  };
}
