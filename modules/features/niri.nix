{self, ...}: {
  flake.nixosModules.niri = {
    pkgs,
    lib,
    config,
    ...
  }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri or pkgs.niri;
      useNautilus = false;
    };
    home.desktops.niri.settings = let
      cfg = config.preferences;
      theme = cfg.theme;
      toList = v:
        if builtins.isList v
        then v
        else [v];
      resolveItem = item:
        if lib.isDerivation item
        then lib.getExe item
        else item;
      toBind = name: val: _: (
        {
          content =
            if val.shell
            then {spawn-sh = lib.concatStringsSep " " (map resolveItem (toList val.action));}
            else {spawn = map resolveItem (toList val.action);};
        }
        // lib.optionalAttrs (val.allowLocked != null) {props.allow-when-locked = val.allowLocked;}
      );
      toOutput = name: val:
        if !val.enable
        then {off = _: {};}
        else
          {
            mode =
              "${toString val.width}x${toString val.height}"
              + lib.optionalString (val.refreshRate != null) "@${toString val.refreshRate}";
          }
          // lib.optionalAttrs val.primary {focus-at-startup = _: {};}
          // lib.optionalAttrs (val.position != null) {
            position = _: {props = {inherit (val.position) x y;};};
          };
    in {
      includes =
        lib.optional (theme.provider != null)
        {
          value = "./${theme.provider}.kdl";
          optional = true;
        };
      input.mouse = lib.filterAttrs (_: v: v != null) {
        accel-profile = cfg.mouse.accelProfile;
        accel-speed = cfg.mouse.accelSpeed;
        scroll-factor = cfg.mouse.scrollFactor;
        natural-scroll =
          if cfg.mouse.naturalScroll == true
          then _: {}
          else null;
      };
      blur =
        if theme.blur.enable
        then {
          passes = 2;
          offset = 3.0;
          noise = 0.03;
          saturation = 1.0;
        }
        else {off = _: {};};
      binds = lib.mapAttrs toBind cfg.binds;
      windowRules =
        (lib.optional (theme.corner.radius > 0) {
          geometry-corner-radius = theme.corner.radius;
          clip-to-geometry = true;
        })
        ++ (lib.optional theme.blur.enable {
          background-effects.blur = true;
        })
        ++ cfg.wm.rules.windows;
      layerRules = cfg.wm.rules.layers;
      outputs = lib.mapAttrs toOutput cfg.monitors;
    };
  };
}
