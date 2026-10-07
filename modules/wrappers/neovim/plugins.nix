{
  flake.wrappers.neovim = {
    lib,
    pkgs,
    config,
    ...
  }: let
    mkNullOption = type:
      lib.mkOption {
        type = lib.types.nullOr type;
        default = null;
      };
    typeOrListOfType = type: lib.types.either type (lib.types.listOf type);
    strOrListOfStrType = typeOrListOfType lib.types.str;

    namedSetupType = lib.types.submodule {
      options = {
        setup = mkNullOption (lib.types.attrsOf lib.types.anything);
      };
    };

    afterFnType = lib.types.submodule {
      freeformType = lib.types.attrsOf namedSetupType;
      options = {
        setup = lib.mkOption {
          type = lib.types.nullOr (lib.types.attrsOf lib.types.anything);
          default = {};
        };
        extraConfig = mkNullOption lib.types.str;
      };
    };

    beforeFnType = lib.types.submodule {
      freeformType = lib.types.attrsOf namedSetupType;
      options = {
        extraConfig = mkNullOption lib.types.str;
      };
    };

    eventType = lib.types.either strOrListOfStrType (lib.types.submodule {
      options = {
        event = mkNullOption strOrListOfStrType;
        pattern = mkNullOption strOrListOfStrType;
      };
    });

    keyType = lib.types.listOf (
      lib.types.coercedTo lib.types.str
      (key: {inherit key;})
      (lib.types.submodule {
        options = {
          key = lib.mkOption {type = lib.types.str;};
          action = mkNullOption lib.types.str;
          description = mkNullOption lib.types.str;
          mode = mkNullOption strOrListOfStrType;
        };
      })
    );

    pluginType = lib.types.submodule {
      options = {
        package = mkNullOption (typeOrListOfType lib.types.package);
        enabled = mkNullOption lib.types.bool;
        beforeAll = mkNullOption beforeFnType;
        before = mkNullOption beforeFnType;
        after = lib.mkOption {
          type = lib.types.nullOr afterFnType;
          default = {setup = {};};
        };
        event = mkNullOption eventType;
        cmd = mkNullOption strOrListOfStrType;
        ft = mkNullOption strOrListOfStrType;
        keys = mkNullOption keyType;
        colorscheme = mkNullOption strOrListOfStrType;
        lazy = mkNullOption lib.types.bool;
        priority = mkNullOption lib.types.int;
      };
    };

    mkSetupCall = name: args:
      if args == null
      then null
      else "require(\"${name}\").setup(${
        if args == {}
        then ""
        else lib.generators.toLua {} args
      })";

    mkHook = pluginName: isAfter: fn:
      if fn == null
      then null
      else let
        namedEntries = lib.filterAttrs (n: _: n != "setup" && n != "extraConfig") fn;
        hasSelfSetupKey = namedEntries ? ${pluginName};
        selfSetup =
          if isAfter
          then
            assert lib.assertMsg (!hasSelfSetupKey)
            "Neovim plugin \"${pluginName}\": use `setup` instead of `\"${pluginName}\".setup` for the plugin's own setup call in after";
              mkSetupCall pluginName (fn.setup or null)
          else
            assert lib.assertMsg (!hasSelfSetupKey)
            "Neovim plugin \"${pluginName}\": setup for the plugin itself is not allowed in before and beforeAll, only in after"; null;

        namedSetups = lib.mapAttrsToList (name: v: mkSetupCall name (v.setup or null)) namedEntries;

        parts = lib.filter (s: s != null && s != "") ([selfSetup] ++ namedSetups ++ [(fn.extraConfig or null)]);
      in
        if parts == []
        then null
        else "function(plugin)\n\t${lib.concatStringsSep "\n\t" parts}\nend";

    mkEvent = ev:
      if ev == null
      then null
      else if builtins.isString ev
      then
        (
          if ev == ""
          then null
          else lib.generators.toLua {} ev
        )
      else if builtins.isList ev
      then
        (
          if ev == []
          then null
          else lib.generators.toLua {} ev
        )
      else let
        filtered = lib.filterAttrs (_: v: v != null) {inherit (ev) event pattern;};
      in
        if filtered == {}
        then null
        else lib.generators.toLua {} filtered;

    mkKeys = ks:
      if ks == null || ks == []
      then null
      else let
        mkOne = k: let
          positional = [k.key] ++ lib.optional (k.action != null) k.action;
          named = lib.filterAttrs (_: v: v != null) {
            desc = k.description;
            mode = k.mode;
          };
          parts =
            map (v: lib.generators.toLua {} v) positional
            ++ lib.mapAttrsToList (n: v: "${n} = ${lib.generators.toLua {} v}") named;
        in "{ ${lib.concatStringsSep ", " parts} }";
      in "{ ${lib.concatStringsSep ", " (map mkOne ks)} }";

    mkPluginSpec = name: plugin: let
      simple = lib.filterAttrs (_: v: v != null) {
        inherit (plugin) enabled cmd ft colorscheme lazy priority;
      };
      simpleFields = lib.mapAttrs (_: v: lib.generators.toLua {} v) simple;

      custom = lib.filterAttrs (_: v: v != null) {
        event = mkEvent plugin.event;
        keys = mkKeys plugin.keys;
        beforeAll = mkHook name false plugin.beforeAll;
        before = mkHook name false plugin.before;
        after = mkHook name true plugin.after;
      };

      allFields = simpleFields // custom;
      fieldLines = lib.mapAttrsToList (k: v: "\t${k} = ${v},") allFields;
    in ''
      {
        "${name}",
      ${lib.concatStringsSep "\n" fieldLines}
      }'';
  in {
    options = {
      plugins = lib.mkOption {
        type = lib.types.attrsOf pluginType;
        default = {};
      };
      lazyPlugins = lib.mkOption {
        type = lib.types.attrsOf pluginType;
        default = {};
      };
    };
    config = let
      mkPluginSpecs = name: extra: pluginsAttr: let
        declared = lib.filterAttrs (_: p: p.package != null) pluginsAttr;
        allPackages = lib.flatten (lib.mapAttrsToList (_: p: lib.toList p.package) declared);
        specTables = lib.mapAttrsToList mkPluginSpec declared;
      in
        lib.optionalAttrs (specTables != []) {
          ${name} =
            extra
            // {
              data = allPackages;
              config = lib.mkIf (config.mode == "static") ''
                require("lz.n").load {
                  ${lib.concatStringsSep ",\n" specTables}
                }
              '';
            };
        };
    in {
      specs =
        {lz-n.data = [pkgs.vimPlugins.lz-n];}
        // mkPluginSpecs "plugins" {} config.plugins
        // mkPluginSpecs "lazyPlugins" {lazy = true;} config.lazyPlugins;
    };
  };
}
