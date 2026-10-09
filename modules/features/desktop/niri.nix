{self, ...}: {
  flake.nixosModules.niri = {
    pkgs,
    config,
    wlib,
    lib,
    ...
  }: let
    toNiriBind = {
      action,
      shell,
      allowLocked ? null,
      ...
    }: let
      act =
        if shell
        then {
          spawn-sh =
            if builtins.isList action
            then lib.escapeShellArgs action
            else action;
        }
        else {spawn = action;};
    in
      if allowLocked == null
      then act
      else
        _: {
          props.allow-when-locked = allowLocked;
          content = act;
        };
    toNiriOutput = name: val:
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
    transformRule = rule: let
      existingMatches =
        if rule ? matches
        then
          if builtins.isList rule.matches
          then rule.matches
          else [rule.matches]
        else [];

      # Добавляем match, если он есть
      matches =
        if rule ? match
        then existingMatches ++ [rule.match]
        else existingMatches;
    in
      if rule ? match || rule ? matches
      then (removeAttrs rule ["match" "matches"]) // {inherit matches;}
      else rule;
    cfg = config.preferences;
    style = config.appearance;
    niri = self.wrappers.niri or (wlib.wrapModule wlib.wrapperModules.btop);
  in {
    programs.niri = {
      enable = true;
      useNautilus = false;
      package = niri.wrap {
        inherit pkgs;
        settings =
          {
            outputs = lib.mapAttrs toNiriOutput cfg.monitors;
            binds = lib.mapAttrs (_: toNiriBind) cfg.binds;
            window-rules =
              (lib.optional (style.rounding > 0) {
                geometry-corner-radius = style.rounding;
                clip-to-geometry = true;
              })
              ++ (lib.optional style.blur.enable {
                background-effect.blur = true;
              })
              ++ (map transformRule cfg.wm.rules.windows);
            layer-rules = map transformRule cfg.wm.rules.layers;
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
              if style.blur.enable
              then {
                passes = style.blur.passes;
                offset = style.blur.size;
                noise = style.blur.noise;
                saturation = style.blur.saturation;
              }
              else {off = _: {};};
          }
          // lib.optionalAttrs (style.colors != null) (with style.colors.withHashtag; {
            layout = {
              focus-ring = {
                active-color = base0E;
                inactive-color = base00;
                urgent-color = base08;
              };
              border = {
                active-color = base0E;
                inactive-color = base00;
                urgent-color = base08;
              };
              tab-indicator = {
                active-color = base0E;
                inactive-color = base00;
                urgent-color = base08;
              };
              insert-hint = {
                color = base0E;
              };
            };
            recent-windows.highlight = {
              active-color = base0E;
              urgent-color = base08;
            };
          });
      };
    };
  };
}
