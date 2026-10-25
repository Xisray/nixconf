{
  flake.nixosModules.btop = {
    config,
    lib,
    ...
  }: let
    appearance = config.appearance;
    hasScheme = appearance.scheme != null;
    toBtopConf = lib.generators.toKeyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault {
        mkValueString = v:
          if builtins.isBool v
          then
            (
              if v
              then "True"
              else "False"
            )
          else if builtins.isString v
          then ''"${v}"''
          else lib.generators.mkValueStringDefault {} v;
      } " = ";
    };
  in {
    homefs.directories.".config/btop".files = {
      "themes/nix.theme" = lib.mkIf hasScheme (
        appearance.colors {src = ./btop.theme.mustache;}
      );
      "btop.conf" = {
        value = {
          rounded_corners = appearance.rounding > 0;
          color_theme = lib.mkIf hasScheme "nix";
        };
        generator = toBtopConf;
      };
    };
  };
}
