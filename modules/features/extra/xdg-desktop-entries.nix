{
  flake.hjemExtraModules.xdgDesktopEntries = { config, lib, ... }:
    let
      toPascalCase = str:
        let
          parts = lib.splitString "-" (lib.replaceStrings [ "_" ] [ "-" ]
            (builtins.replaceStrings
              [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M"
                "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" ]
              [ "-A" "-B" "-C" "-D" "-E" "-F" "-G" "-H" "-I" "-J" "-K" "-L" "-M"
                "-N" "-O" "-P" "-Q" "-R" "-S" "-T" "-U" "-V" "-W" "-X" "-Y" "-Z" ]
              str));
          capitalize = s:
            if s == "" then ""
            else (lib.toUpper (lib.substring 0 1 s)) + (lib.substring 1 (lib.stringLength s) s);
        in
          lib.concatStringsSep "" (map capitalize (builtins.filter (p: p != "") parts));

      valueToString = v:
        if lib.isBool v then (if v then "true" else "false")
        else if lib.isList v then lib.concatStringsSep ";" (map valueToString v)
        else if v == null then null
        else if lib.isDerivation v then lib.getExe v
        else toString v;
      
      generateDesktopEntry = attrs:
        let
          filtered = lib.filterAttrs (n: v: v != null && n != "_module") attrs;
          lines = lib.mapAttrsToList (name: value:
            let
              key = toPascalCase name;
              val = valueToString value;
            in
              if val == null then null else "${key}=${val}"
          ) filtered;
        in
          lib.concatStringsSep "\n" ([ "[Desktop Entry]"] ++ (builtins.filter (l: l != null) lines));

      entryType = lib.types.submodule {
        freeformType = 
          let
            primitives = [ lib.types.str lib.types.bool lib.types.int lib.types.float lib.types.path ];
          in lib.types.attrsOf (lib.types.oneOf (primitives ++ [ (lib.types.listOf (lib.types.oneOf primitives)) ]));
        options = {
          version = lib.mkOption { type = lib.types.str; default = "1.0"; };
          name = lib.mkOption { type = lib.types.str; description = "Name="; };
          genericName = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
          comment = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
          icon = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
          exec = lib.mkOption { type = (lib.types.either lib.types.package lib.types.str); };
          terminal = lib.mkOption { type = lib.types.nullOr lib.types.bool; default = null; };
          type = lib.mkOption { type = lib.types.str; default = "Application"; };
          categories = lib.mkOption { type = lib.types.nullOr (lib.types.listOf lib.types.str); default = null; };
          mimeType = lib.mkOption { type = lib.types.nullOr (lib.types.listOf lib.types.str); default = null; };
          noDisplay = lib.mkOption { type = lib.types.nullOr lib.types.bool; default = null; };
        };
      };
  in {
    options.xdg.desktop-entries = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either
        (lib.types.either lib.types.path lib.types.str)
        entryType
      );
      default = { };
    };
    config.xdg.data.files = lib.mapAttrs' (name: value:
      lib.nameValuePair "applications/${name}.desktop" (
        if lib.isPath value || lib.isString value then { source = value; }
        else { text = generateDesktopEntry value; }
      )
    ) config.xdg.desktop-entries;
  };
}
