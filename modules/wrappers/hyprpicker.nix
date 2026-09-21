{
  flake.wrappers.hyprpicker = { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];
    package = pkgs.hyprpicker;
    runtimePkgs = with pkgs; [
      wl-clipboard
      libnotify
    ];
  };
}
