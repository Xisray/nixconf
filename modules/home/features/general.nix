{ self, inputs, ... }: {
  flake.homeModules.general =
    { config, pkgs, ... }:
    let
      cliamp = inputs.cliamp.packages.${pkgs.system}.default;

      cliampWithYandex = pkgs.writeShellScriptBin "cliamp" ''
        export YANDEX_MUSIC_TOKEN="$(cat ${config.sops.secrets.yandex_music_token.path})"
        exec ${cliamp}/bin/cliamp "$@"
      '';
    in
    {
      imports = [
        self.homeModules.ocr
        self.homeModules.colorPicker
        self.homeModules.sops
      ];
      home.packages = with pkgs; [
        wl-clipboard
        devenv
        cliampWithYandex
      ];
      services.udiskie = {
        enable = true;
      };
    };
}
