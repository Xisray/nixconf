{ self, ... }: {
  flake.wrappers.udiskie = { pkgs, wlib, config, lib, ... }: {
    imports = [ wlib.modules.default ];
    package = pkgs.udiskie;
    runtimePkgs = with pkgs; [
      libnotify
      xdg-utils
    ];
    constructFiles.udiskie-config = {
      relPath = "share/udiskie/config.yml";
      content = ''
        program_options:
          tray: auto
          notify: true
          automount: true
      '';
    };
    flags."-c" = config.constructFiles.udiskie-config.path;
  };
}
