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
      processName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      tdata = lib.mkOption {
        type = lib.types.str;
        default = ".local/share/TelegramDesktop/tdata";
      };
      theme = lib.mkOption {
        type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
        default = null;
      };
    };
    config = let
      processName =
        if config.processName != null
        then config.processName
        else config.package.meta.mainProgram or (lib.getName config.package);
      python = pkgs.python3.withPackages (ps: [ps.cryptography]);
      applyTheme =
        if config.theme == null
        then null
        else
          (pkgs.writeShellApplication {
            name = "${processName}-apply-theme";
            excludeShellChecks = ["SC2016"];
            runtimeInputs = [
              python
              pkgs.procps
            ];
            text = ''
              export PYTHONPATH=${./.}
              export TG_THEME=${lib.escapeShellArg config.theme}
              export TG_TDATA=${lib.escapeShellArg config.tdata}
              export TG_PROCESS=${lib.escapeShellArg processName}
              python - <<'EOF' || true
              import os
              from pathlib import Path
              from tg_config.theme import apply_theme

              apply_theme(
                Path(os.path.expandvars(os.environ["TG_THEME"])),
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
