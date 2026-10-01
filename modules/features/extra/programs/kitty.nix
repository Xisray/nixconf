{
  flake.hjemExtraModules.programs = {
    lib,
    pkgs,
    config,
    osConfig,
    ...
  }: {
    options.programs.kitty = let
      mkShellIntegrationOption = shell:
        lib.mkOption {
          type = lib.types.bool;
          default = osConfig.programs.${shell}.enable;
        };
    in {
      enable = lib.mkEnableOption "kitty";
      package = lib.mkPackageOption pkgs "kitty" {nullable = true;};
      includes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      settings = lib.mkOption {
        type = with lib.types; attrsOf (oneOf [str bool int float]);
        default = {};
      };
      shellIntegration = {
        mode = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "no-rc";
          example = "no-cursor";
          apply = lib.mapNullable (
            o: let
              modes = lib.splitString " " o;
              filtered = lib.filter (m: m != "no-rc") modes;
            in
              lib.concatStringsSep " " (
                lib.concatLists [
                  ["no-rc"]
                  filtered
                ]
              )
          );
        };
        enableFishIntegration = mkShellIntegrationOption "fish";
      };
    };
    config = let
      cfg = config.programs.kitty;
      toYesNo = val:
        if val
        then "yes"
        else "no";
      toInclude = inc: "include ${inc}";
      toKittyConf = lib.generators.toKeyValue {
        mkKeyValue = key: value: "${key} ${(
            if lib.isBool value
            then toYesNo
            else toString
          )
          value}";
      };
    in
      lib.mkIf cfg.enable {
        assertions = [
          {
            assertion =
              !(
                cfg.shellIntegration.mode
                == null
                && (
                  cfg.shellIntegration.enableBashIntegration
                  || cfg.shellIntegration.enableFishIntegration
                  || cfg.shellIntegration.enableZshIntegration
                )
              );
            message = "Cannot enable shell integration when `programs.kitty.shellIntegration.mode` is `null`";
          }
        ];
        packages = lib.optional (cfg.package != null) cfg.package;
        xdg.config.files."kitty/kitty.conf".text =
          lib.mkIf (cfg.settings != {} || cfg.includes != [])
          (lib.concatStringsSep "\n" (
            lib.optional (cfg.shellIntegration.mode != null) "shell_integration ${cfg.shellIntegration.mode}"
            ++ (map toInclude cfg.includes)
            ++ lib.optional (cfg.settings != {}) (toKittyConf cfg.settings)
          ));
      };
  };
}
