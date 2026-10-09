{
  flake.nixosModules.gtk = {
    pkgs,
    lib,
    config,
    ...
  }: let
    style = config.appearance;
  in {
    environment.systemPackages = [
      pkgs.adw-gtk3
    ];
    programs.dconf.enable = true;

    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config.common.default = ["gtk"];
    };

    environment = {
      sessionVariables = {
        GTK_THEME = "adw-gtk3";
      };
      etc = lib.mkIf (style.scheme != null) (let
        css = style.colors {
          template = ./base16.css.mustache;
          extension = ".css";
        };
      in {
        "xdg/gtk-3.0/gtk.css".source = css;
        "xdg/gtk-4.0/gtk.css".source = css;
      });
    };
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" =
          {
            gtk-theme = "adw-gtk3";
            font-name = "${style.fonts.sansSerif.name} ${toString style.fonts.sizes.applications}";
            color-scheme = "prefer-${style.polarity}";
          }
          // lib.optionalAttrs (style.icons != null) {
            icon-theme = style.icons.${style.polarity};
          }
          // lib.optionalAttrs (style.cursor != null) {
            cursor-theme = style.cursor.name;
            cursor-size = style.cursor.size;
          };
      }
    ];
  };
}
