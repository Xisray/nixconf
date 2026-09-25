{ self, ... }: {
  flake.wrappers.udiskie = { pkgs, wlib, config, lib, ... }: {
    imports = [ wlib.modules.default ];
    package = pkgs.udiskie;
    runtimePkgs = [
      pkgs.libnotify
    ];
  };
}
