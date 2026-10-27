{inputs, ...}: {
  flake.wrappers.cliamp = {
    wlib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];
    package = inputs.cliamp.packages.${pkgs.stdenv.hostPlatform.system}.default or pkgs.cliamp;
    constructFiles.config = {
      relPath = "share/cliamp/config.toml";
      content = ''
        [yandex]
        enabled = true
        token = "$YANDEX_MUSIC_TOKEN"
      '';
    };
    env = {
      CLIAMP_CONFIG_DIR = {
        data = "${dirOf config.constructFiles.config.path}";
        esc-fn = wlib.escapeShellArgWithEnv;
      };
      YANDEX_MUSIC_TOKEN = {
        data = "$(cat /run/secrets/yandex_music_api_key)";
        esc-fn = wlib.escapeShellArgWithEnv;
      };
    };
  };
}
