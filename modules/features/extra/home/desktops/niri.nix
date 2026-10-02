{
  flake.hjemExtraModules.home = {
    lib,
    config,
    osConfig,
    elib,
    ...
  }: {
    options.desktops.niri = {
      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = with lib.types; attrsOf anything;
          options = {
            includes =
              lib.mkOption
              (let
                includeType = lib.types.submodule {
                  options = {
                    optional = lib.mkOption {
                      type = lib.types.nullOr lib.types.bool;
                      default = null;
                    };
                    value = lib.mkOption {
                      type = lib.types.str;
                    };
                  };
                };
              in {
                type = with lib.types;
                  listOf includeType;
                default = [];
              });
            outputs = lib.mkOption {
              type = with lib.types; attrsOf anything;
              default = {};
            };
            windowRules = lib.mkOption {
              type = with lib.types; listOf (attrsOf anything);
              default = [];
            };
            layerRules = lib.mkOption {
              type = with lib.types; listOf (attrsOf anything);
              default = [];
            };
            spawnAtStartup = lib.mkOption {
              type = with lib.types; listOf (either str (listOf str));
              default = [];
            };
            spawnShAtStartup = lib.mkOption {
              type = with lib.types; listOf str;
              default = [];
            };
            # workspaces;
            extraConfig = lib.mkOption {
              type = lib.types.lines;
              default = "";
            };
          };
        };
        default = {};
      };
    };
    config.xdg.config.files."niri/config.kdl".text =
      lib.mkIf osConfig.programs.niri.enable
      (let
        cfg = config.desktops.niri;
        mkOutput = mon: val: {
          output = _: {
            props = [mon];
            content = val;
          };
        };
        mkInclude = val: {
          include =
            [val.value]
            ++ lib.optional (val.optional != null) {optional = val.optional;};
        };
        toList = x:
          if x == null
          then []
          else lib.toList x;
        mkRule = node: r: let
          allMatches = toList (r.matches or null) ++ toList (r.match or null);
          matches = map (m: {match = _: {props = m;};}) allMatches;
          allExcludes = toList (r.excludes or null) ++ toList (r.exclude or null);
          excludes = map (m: {exclude = _: {props = m;};}) allExcludes;
          other = lib.mapAttrsToList (n: v: {${n} = v;}) (
            lib.attrsets.removeAttrs r ["matches" "match" "excludes" "exclude"]
          );
        in {
          ${node} = matches ++ excludes ++ other;
        };

        settings = removeAttrs cfg ["includes" "outputs" "windowRules" "layerRules" "spawnAtStartup" "spawnShAtStartup" "extraConfig"];
        spawns =
          map (c: {spawn-at-startup = lib.toList c;}) cfg.spawnAtStartup
          ++ map (c: {spawn-sh-at-startup = c;}) cfg.spawnShAtStartup;
        toKdlV1 = value:
          elib.toKdl (_: {
            version = 1;
            content = value;
          });
      in ''
        ${toKdlV1 (map mkInclude cfg.includes)}
        ${toKdlV1 (lib.mapAttrsToList mkOutput cfg.outputs)}
        ${toKdlV1 spawns}
        ${toKdlV1 settings}
        ${toKdlV1 (map (mkRule "window-rule") cfg.windowRules)}
        ${toKdlV1 (map (mkRule "layer-rule") cfg.layerRules)}
        ${cfg.extraConfig}
      '');
  };
}
