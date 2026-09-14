{ inputs, ... }: {
  flake.homeModules.cliamp =
    { pkgs, config, ... }:
    let
      cliamp = inputs.wrapper-modules.lib.wrapPackage {
        package = inputs.cliamp.packages.${pkgs.system}.default;
        env = {
          YANDEX_MUSIC_TOKEN = config.sops.secrets.yandex_music_token.path;
        };
      };
    in
    {
      sops.secrets.yandex_music_token = { };
      home.packages = [
        cliamp
      ];
      xdg.configFile."cliamp/config.toml".text = ''
        [yandex]
        enabled = true
        token = "$YANDEX_MUSIC_TOKEN"
      '';
    };
}
