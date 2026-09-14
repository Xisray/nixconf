{ self, inputs, ... }: {
  flake.homeModules.general = { pkgs, ... }: {
    imports = [
      self.homeModules.ocr
      self.homeModules.colorPicker
    ];
    home.packages = with pkgs; [
      wl-clipboard
      devenv
      inputs.cliamp.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    services.udiskie = {
      enable = true;
    };
  };
}
