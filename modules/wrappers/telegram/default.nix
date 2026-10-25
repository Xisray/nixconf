{
  flake.wrappers.telegram = {
    wlib,
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];
    options = {
      theme = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
      background = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      tdata = lib.mkOption {
        type = lib.types.str;
        default = ".local/share/TelegramDesktop/tdata";
      };
      processName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
    config = let
      processName =
        if config.processName != null
        then config.processName
        else config.package.meta.mainProgram or (lib.getName config.package);
      python = pkgs.python3.withPackages (ps: [ps.cryptography]);
      themeFile =
        if config.theme == null
        then null
        else if config.background == null
        then config.theme
        else
          pkgs.runCommand "telegram.tdesktop-theme"
          {
            nativeBuildInputs = [
              pkgs.zip
              pkgs.imagemagick
            ];
          }
          ''
            mkdir t && cd t
            cp ${config.theme} colors.tdesktop-theme
            magick -size 64x64 xc:'#${config.background}' background.png
            zip -X "$out" colors.tdesktop-theme background.png
          '';
      applyTheme =
        if themeFile == null
        then null
        else
          (pkgs.writeShellApplication {
            name = "${processName}-apply-theme";
            runtimeInputs = [
              python
              pkgs.procps
            ];
            text = ''
              export PYTHONPATH=${./.}
              export TG_THEME=${lib.escapeShellArg "${themeFile}"}
              export TG_TDATA=${lib.escapeShellArg config.tdata}
              export TG_PROCESS=${lib.escapeShellArg processName}
              python - <<'EOF' || true
              import os
              from pathlib import Path
              from tg_config.theme import apply_theme

              apply_theme(
                Path(os.environ["TG_THEME"]),
                Path.home() / os.environ["TG_TDATA"],
                app=os.environ["TG_PROCESS"],
              )
              EOF
            '';
          });
    in {
      package = lib.mkDefault pkgs.telegram-desktop;
      runShell = lib.optional (applyTheme != null) {
        name = "apply-theme";
        data = lib.getExe applyTheme;
      };
    };
  };
}
