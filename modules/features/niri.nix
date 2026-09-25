{
  self,
  ...
}:
{
  flake.nixosModules.niri =
    {
      pkgs,
      lib,
      config,
      wlib,
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = (self.packages.${pkgs.stdenv.hostPlatform.system}.niri or pkgs.niri);
      };

      home.files.".config/niri/config.kdl".text =
        let
          cfg = config.preferences;
          blur =
            if cfg.ui.blur.enabled then
              {
                passes = 2;
                offset = 3.0;
                noise = 0.03;
                saturation = 1.0;
              }
            else
              { off = _: { }; };

          mouse = lib.filterAttrs (_: v: v != null) {
            accel-profile = cfg.mouse.accelProfile;
            accel-speed = cfg.mouse.accelSpeed;
            scroll-factor = cfg.mouse.scrollFactor;
            natural-scroll = if cfg.mouse.naturalScroll == true then _: { } else null;
          };
          binds =
            let
              toContent =
                action:
                if builtins.isList action then
                  { spawn = map (a: if lib.isDerivation a then lib.getExe a else a) action; }
                else if lib.isDerivation action then
                  { spawn = [ (lib.getExe action) ]; }
                else
                  { spawn-sh = action; };

              toBind =
                {
                  action,
                  allowLocked ? null,
                }:
                let
                  content = toContent action;
                in
                if allowLocked == null then
                  content
                else
                  (_: {
                    props = {
                      allow-when-locked = allowLocked;
                    };
                    inherit content;
                  });
            in
            lib.mapAttrs (_: toBind) cfg.binds;

          mkMonitor =
            name: cfg:
            let
              content =
                if cfg.enabled or true == false then
                  {
                    off = _: { };
                  }
                else
                  let
                    mode =
                      "${toString cfg.width}x${toString cfg.height}"
                      + lib.optionalString (cfg ? refreshRate && cfg.refreshRate != null) "@${toString cfg.refreshRate}";

                    base = removeAttrs cfg [
                      "width"
                      "height"
                      "refreshRate"
                      "primary"
                      "position"
                      "enabled"
                    ];
                  in
                  base
                  // {
                    inherit mode;

                    position = _: {
                      props = {
                        x = cfg.position.x;
                        y = cfg.position.y;
                      };
                    };
                  }
                  // lib.optionalAttrs (cfg.primary or false) {
                    focus-at-startup = _: { };
                  };
            in
            {
              output = _: {
                props = name;
                inherit content;
              };
            };
          output = lib.mapAttrsToList mkMonitor cfg.monitors;

          toList = x: if x == null then [ ] else lib.toList x;

          mkRule =
            node: r:
            let
              allMatches = toList (r.matches or null) ++ toList (r.match or null);
              matches = map (m: { match = _: { props = m; }; }) (toList allMatches);
              excludes = map (m: { exclude = _: { props = m; }; }) (r.excludes or [ ]);
              other = lib.mapAttrsToList (n: v: { ${n} = v; }) (
                lib.attrsets.removeAttrs r [
                  "matches"
                  "excludes"
                  "match"
                ]
              );
            in
            {
              ${node} = matches ++ excludes ++ other;
            };

          settings = {
            inherit blur;
            input.mouse = mouse;
            binds = binds;
          };
	  toKdlV1 = value: wlib.toKdl (_: {
	    version = 1;
	    content = value;
	  });
        in
        ''
	  include optional=true "./noctalia.kdl"
          ${toKdlV1 settings}
          ${toKdlV1 output}
          ${toKdlV1 (map (mkRule "window-rule") cfg.wm.rules.windows)}
          ${toKdlV1 (map (mkRule "layer-rule") cfg.wm.rules.layers)}
        '';
    };
}
