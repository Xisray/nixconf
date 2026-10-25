{
  flake.nixosModules.appearance = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.gtk.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.gtk.enable) {
      homefs.files.".config/gtk-3.0/gtk.css" = lib.mkIf (cfg.hasScheme) (cfg.colors {src = ./gtk3.css.mustache;});
      homefs.files.".config/gtk-4.0/gtk.css" = lib.mkIf (cfg.hasScheme) (cfg.colors {src = ./gtk4.css.mustache;});
      environment.systemPackages = [
        pkgs.adw-gtk3
      ];
      xdg.portal = {
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
        config.common.default = ["gtk"];
      };
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings."org/gnome/desktop/interface" =
              {
                gtk-theme =
                  if cfg.polarity == "dark"
                  then "adw-gtk3-dark"
                  else "adw-gtk3";
                font-name = "${cfg.fonts.sansSerif.name} ${toString cfg.fonts.sizes.applications}";
                color-scheme = "prefer-${cfg.polarity}";
              }
              // lib.optionalAttrs (cfg.icons != null) {
                icon-theme = cfg.icons.${cfg.polarity};
              }
              // lib.optionalAttrs (cfg.cursor != null) {
                cursor-theme = cfg.cursor.name;
                cursor-size = lib.gvariant.mkUint32 cfg.cursor.size;
              };
          }
        ];
      };
    };
  };
}
