{
  flake.homeModules.yazi =
    {
      osConfig,
      pkgs,
      lib,
      ...
    }:
    {
      programs.yazi = {
        enable = true;
        theme = {
          mode.normal_alt.bg = lib.mkForce osConfig.lib.stylix.colors.withHashtag.base02;
        };
      };
      xdg.mimeApps.defaultApplications."inode/directory" = [ "yazi.desktop" ];
      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME
        env=PATH="$PATH:/run/current-system/sw/bin"
        open_mode=suggested
        save_mode=last
      '';
    };
}
