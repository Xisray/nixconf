{self, ...}: {
  flake.shellModules.yazi = {
    module = {
      lib,
      pkgs,
      appearance,
      ...
    }: let
      yaziWrapper = self.wrappers.yazi or null;
    in {
      packages.yazi = lib.mkIf (yaziWrapper != null && (appearance.rounding != 0 || appearance.scheme != null)) (yaziWrapper.wrap {
        inherit pkgs;
        settings.theme = let
          block = {
            open =
              if (appearance.rounding == 0)
              then "█"
              else "";
            close =
              if (appearance.rounding == 0)
              then "█"
              else "";
          };
        in {
          status.sep_left = block;
          status.sep_right = block;
          indicator.padding = block;
          flavor = lib.mkIf (appearance.scheme != null) {
            dark = "nix";
            light = "nix";
          };
        };
        flavors.nix = lib.mkIf (appearance.scheme != null) (pkgs.linkFarm "yazi-flavor-nix" [
          {
            name = "flavor.toml";
            path = appearance.colors {
              src = ./yazi.toml.mustache;
            };
          }
          {
            name = "tmtheme.xml";
            path = appearance.colors {
              src = ../bat/bat.tmTheme.mustache;
              ext = ".xml";
            };
          }
        ]);
      });
    };
    nixos = {
      lib,
      pkgs,
      shellPackages,
      ...
    }: {
      user.packages = [
        shellPackages.yazi
      ];
      xdg = {
        portal = {
          extraPortals = with pkgs; [
            xdg-desktop-portal-termfilechooser
          ];
          config = lib.genAttrs ["common" "sway" "hyprland" "niri" "gnome" "kde"] (_: {"org.freedesktop.impl.portal.FileChooser" = lib.mkForce "termfilechooser";});
        };
        mime.defaultApplications = {
          "inode/directory" = ["yazi.desktop"];
          "inode/mount-point" = ["yazi.desktop"];
        };
      };
      systemd.user.tmpfiles.rules = let
        termfilechooserConfig = pkgs.writeText "termfilechooser-config" ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          default_dir=$HOME
          env=PATH=$PATH:/run/current-system/sw/bin
          env=TERMCMD=${lib.getExe pkgs.xdg-terminal-exec} --app-id=termfilechooser
          open_mode=suggested
          save_mode=last
        '';
      in [
        "d %h/.config/xdg-desktop-portal-termfilechooser 0755 - - -"
        "L+ %h/.config/xdg-desktop-portal-termfilechooser/config - - - - ${termfilechooserConfig}"
      ];
      preferences.wm.rules.windows = [
        {
          match.app-id = "^termfilechooser$";
          open-floating = true;
          default-window-height.proportion = 0.6;
          default-column-width.proportion = 0.45;
        }
      ];
    };
  };
}
