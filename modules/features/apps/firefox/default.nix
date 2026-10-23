{
  flake.nixosModules.firefox = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.programs.firefox = {
      userChrome = lib.mkOption {
        type = lib.types.nullOr (lib.types.oneOf [lib.types.str lib.types.path lib.types.package]);
        default = null;
      };
      userContent = lib.mkOption {
        type = lib.types.nullOr (lib.types.oneOf [lib.types.str lib.types.path lib.types.package]);
        default = null;
      };
    };

    config = let
      cfg = config.programs.firefox;
      style = config.appearance;
      hasColors = style.scheme != null;
      fonts = style.fonts;
      hasStylesheets = cfg.userChrome != null || cfg.userContent != null;

      profileName = "nix";
      profilesIni =
        if (hasStylesheets || hasColors)
        then
          (pkgs.writeText "profiles.ini" ''
            [General]
            StartWithLastProfile=1
            Version=2

            [Profile0]
            Name=${profileName}
            IsRelative=1
            Path=${profileName}
            Default=1
          '')
        else null;
      addonId = "FirefoxColor@mozilla.com";

      userChrome = let
        val = cfg.userChrome;
        isFile =
          val
          != null
          && (
            builtins.isPath val
            || lib.isDerivation val
            || (builtins.isString val && lib.hasPrefix builtins.storeDir val)
          );
      in
        if val == null
        then null
        else if isFile
        then val
        else pkgs.writeText "userChrome.css" val;
      userContent = let
        val = cfg.userContent;
        isFile =
          val
          != null
          && (
            builtins.isPath val
            || lib.isDerivation val
            || (builtins.isString val && lib.hasPrefix builtins.storeDir val)
          );
      in
        if val == null
        then null
        else if isFile
        then val
        else pkgs.writeText "userContent.css" val;
      mkColor = color: {
        r = style.colors."${color}-rgb-r";
        g = style.colors."${color}-rgb-g";
        b = style.colors."${color}-rgb-b";
      };
      storageJs =
        if !hasColors
        then null
        else
          (pkgs.writeText "storage.js" (builtins.toJSON {
            firstRunDone = true;
            theme = {
              title = "Nix";
              images.additional_backgrounds = ["./bg-000.svg"];
              colors = {
                toolbar = mkColor "base00";
                toolbar_text = mkColor "base05";
                frame = mkColor "base01";
                frame_inactive = mkColor "base00";
                tab_background_text = mkColor "base05";
                tab_line = mkColor "primary";
                tab_selected = mkColor "base00";
                tab_text = mkColor "base05";
                tab_loading = mkColor "primary";
                tab_background_separator = mkColor "primary";
                toolbar_field = mkColor "base01"; #02
                toolbar_field_text = mkColor "base05";
                toolbar_field_border = mkColor "base00";
                toolbar_field_border_focus = mkColor "primary";
                toolbar_field_focus = mkColor "base00";
                toolbar_field_highlight = mkColor "primary";
                toolbar_field_highlight_text = mkColor "base00";
                toolbar_field_separator = mkColor "primary";
                toolbar_bottom_separator = mkColor "base00";
                toolbar_vertical_separator = mkColor "primary";
                popup = mkColor "base00";
                popup_text = mkColor "base05";
                popup_border = mkColor "primary";
                popup_highlight = mkColor "base04"; #??
                popup_highlight_text = mkColor "base05";
                button_background_active = mkColor "base04"; #??
                icons = mkColor "primary";
                icons_attention = mkColor "primary";
                ntp_background = mkColor "base11";
                ntp_text = mkColor "base05";
                sidebar = mkColor "base00";
                sidebar_text = mkColor "base05";
                sidebar_border = mkColor "primary";
                sidebar_highlight = mkColor "primary";
                sidebar_highlight_text = mkColor "base11";
              };
            };
          }));

      link = dst: src: rem:
        if rem
        then "r ${dst}"
        else "L+ ${dst} - - - - ${src}";
    in {
      systemd.user.tmpfiles.rules =
        [
          (link "%h/.mozilla/firefox/${profileName}/chrome/userChrome.css" userChrome (userChrome == null))
          (link "%h/.mozilla/firefox/${profileName}/chrome/userContent.css" userContent (userContent == null))
          (link "%h/.mozilla/firefox/${profileName}/browser-extension-data/${addonId}/storage.js" storageJs (!hasColors))
        ]
        ++ lib.optional (hasColors || hasStylesheets) "C %h/.mozilla/firefox/profiles.ini 0600 - - - ${profilesIni}";

      programs.firefox = {
        userChrome = lib.mkIf (style.rounding == 0) ''
          * {
            border-radius: 0 !important;
          }
        '';
        userContent = lib.mkIf hasColors (style.colors {
          src = ./userContent.css.mustache;
        });
        autoConfig = lib.mkMerge [
          (lib.mkIf hasStylesheets ''
            lockPref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          '')
          (lib.mkIf hasColors ''
            lockPref("extensions.webextensions.ExtensionStorageIDB.enabled", false);
          '')
        ];
        policies = {
          ExtensionSettings.${addonId} = lib.mkIf (style.scheme != null) {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
            installation_mode = "force_installed";
          };
          Preferences = {
            "font.name.monospace.x-western" = {
              Value = fonts.monospace.name;
              Status = "locked";
            };
            "font.name.sans-serif.x-western" = {
              Value = fonts.sansSerif.name;
              Status = "locked";
            };
            "font.name.serif.x-western" = {
              Value = fonts.serif.name;
              Status = "locked";
            };
            "font.size.monospace.x-western" = {
              Value = builtins.floor ((fonts.sizes.terminal * 4.0 / 3.0) + 0.5);
              Status = "locked";
            };
            "font.size.variable.x-western" = {
              Value = builtins.floor ((fonts.sizes.applications * 4.0 / 3.0) + 0.5);
              Status = "locked";
            };
          };
        };
      };
    };
  };
}
