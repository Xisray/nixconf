{ self, ... }: {
  flake.wrappers.lazygit = { pkgs, wlib, config, lib, ... }: {
    imports = [ wlib.modules.default ];
    package = pkgs.lazygit;
    runtimePkgs = [
      (self.packages.${pkgs.stdenv.hostPlatform.system}.git or pkgs.git)
    ];
    constructFiles.lazygit-config = {
      relPath = "share/lazygit/config.yml";
      content = lib.generators.toYAML { } {
        disableStartupPopups = true;
      };
    };
    env.LG_CONFIG_FILE = {
      data = "${config.constructFiles.lazygit-config.path},$HOME/.config/lazygit/config.yml";
      esc-fn = wlib.escapeShellArgWithEnv;
    };
  };
}
