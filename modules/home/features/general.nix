{ self, ... }: {
  flake.homeModules.general = { pkgs, ... }: {
    imports = [
      self.homeModules.ocr
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
