{moduleWithSystem, ...}: {
  flake.nixosModules.niri = moduleWithSystem ({self', ...}: {
    pkgs,
    config,
    lib,
    inputs,
    ...
  }: let
    mkRule = node: r: let
      matches = map (m: {match = _: {props = m;};}) (r.matches or []);
      excludes = map (m: {exclude = _: {props = m;};}) (r.excludes or []);
      other = lib.mapAttrsToList (n: v: {${n} = v;}) (
        lib.attrsets.removeAttrs r [
          "matches"
          "excludes"
        ]
      );
    in {
      ${node} = matches ++ excludes ++ other;
    };
    attrAsArg = node:
      lib.mapAttrsToList (
        n: v: {
          ${node} = s:
            if lib.isFunction v
            then let
              res = v s;
            in
              res
              // {
                props =
                  if res ? props
                  then
                    if builtins.isAttrs res.props
                    then [
                      n
                      res.props
                    ]
                    else if builtins.isList res.props
                    then [n] ++ res.props
                    else n
                  else n;
              }
            else if builtins.isAttrs v
            then {
              content = v;
              props = n;
            }
            else {props = n;};
        }
      );
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

      matches =
        if rule ? match
        then existingMatches ++ [rule.match]
        else existingMatches;
    in
      if rule ? match || rule ? matches
      then
        (removeAttrs rule [
          "match"
          "matches"
        ])
        // {
          inherit matches;
        }
      else rule;
    cfg = config.preferences;

    outputs = lib.mapAttrs toNiriOutput cfg.monitors;
    window-rules = map transformRule cfg.wm.rules.windows;
    layer-rules = map transformRule cfg.wm.rules.layers;
    settings = {
      binds = lib.mapAttrs (_: toNiriBind) cfg.binds;
      input.mouse = lib.filterAttrs (_: v: v != null) {
        accel-profile = cfg.mouse.accelProfile;
        accel-speed = cfg.mouse.accelSpeed;
        scroll-factor = cfg.mouse.scrollFactor;
        natural-scroll =
          if cfg.mouse.naturalScroll == true
          then _: {}
          else null;
      };
    };
  in {
    programs.niri = {
      enable = true;
      useNautilus = false;
      package = self'.packages.niri or pkgs.niri;
    };
    homefs.files.".config/niri/config.kdl".text = let
      toKdl = value:
        inputs.wrappers.lib.toKdl (_: {
          version = 1;
          content = value;
        });
    in ''
      ${toKdl (attrAsArg "output" outputs)}
      ${toKdl settings}
      ${toKdl (map (mkRule "window-rule") window-rules)}
      ${toKdl (map (mkRule "layer-rule") layer-rules)}
    '';
  });
}
