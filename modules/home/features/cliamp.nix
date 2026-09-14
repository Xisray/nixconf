{ inputs, ... }: {
  flake.homeModules.cliamp =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      sops.secrets.yandex_music_token = { };
      home.packages = [
        (pkgs.writeShellScriptBin "cliamp" ''
          export YANDEX_MUSIC_TOKEN="$(cat ${config.sops.secrets.yandex_music_token.path})"
          exec ${lib.getExe inputs.cliamp.packages.${pkgs.system}.default} "$@"
        '')
      ];
      xdg.configFile."cliamp/config.toml" = {
        text = ''
          [yandex]
          enabled = true
          token = "$YANDEX_MUSIC_TOKEN"
        '';
        force = true;
      };
      preferences.binds = {
        "XF86AudioPlay".action = [
          "cliamp"
          "toggle"
        ];
        "XF86AudioNext".action = [
          "cliamp"
          "next"
        ];
        "XF86AudioPrev".action = [
          "cliamp"
          "prev"
        ];
        "Mod+Shift+Space".action = [
          "cliamp"
          "toggle"
        ];
        "Mod+Shift+less".action = [
          "cliamp"
          "next"
        ];
        "Mod+Shift+greater".action = [
          "cliamp"
          "prev"
        ];
      };
    };
}
