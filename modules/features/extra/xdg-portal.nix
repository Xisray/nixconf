{
  flake.hjemExtraModules.xdgPortal = { config, lib, ... }: 
  let
    valueToString = v:
      if lib.isList v then lib.concatStringsSep ";" v
      else toString v;

    generatePortalConf = attrs:
      let
        lines = lib.mapAttrsToList (key: value:
          "${key}=${valueToString value}"
        ) attrs;
      in
        lib.concatStringsSep "\n" ([ "[preferred]" ] ++ lines);

    portalSectionType = lib.types.attrsOf (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
  in {
    options.xdg.portal.config = lib.mkOption {
      type = lib.types.attrsOf portalSectionType;
      default = { };
    };
    config.xdg.config.files = lib.mapAttrs' (name: value:
    let
      fileName = if name == "common" then "xdg-desktop-portal/portals.conf"
      else "xdg-desktop-portal/${name}-portals.conf";
    in lib.nameValuePair fileName {
      generator = generatePortalConf;
      value = value;
    }
    ) config.xdg.portal.config;
  };
}
