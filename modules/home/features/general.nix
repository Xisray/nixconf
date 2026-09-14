{ self, ... }: {
  flake.homeModules.general = { pkgs, ... }: {
    imports = [
      self.homeModules.ocr
      self.homeModules.colorPicker
    ];
    home.packages = with pkgs; [
      devenv
      cliamp
    ];
    services.udiskie = {
      enable = true;
    };
  };
}
