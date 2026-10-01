{
  flake.hjemExtraModules.programs = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.programs.btop = {
      enable = lib.mkEnableOption "btop";
      package = lib.mkPackageOption pkgs "btop" {nullable = true;};
      settings = lib.mkOption {
        type = with lib.types;
          attrsOf (oneOf [
            bool
            float
            int
            str
          ]);
        default = {};
      };
    };
    config = let
      cfg = config.programs.btop;
    in
      lib.mkIf cfg.enable {
        packages = lib.optional (cfg.package != null) cfg.package;
        xdg.config.files."btop/btop.conf" = lib.mkIf (cfg.settings != {}) {
          generator = lib.generators.toKeyValue {
            mkKeyValue = lib.generators.mkKeyValueDefault {
              mkValueString = v:
                if lib.isBool v
                then
                  (
                    if v
                    then "True"
                    else "False"
                  )
                else if lib.isString v
                then ''"${v}"''
                else lib.generators.mkValueStringDefault {} v;
            } " = ";
          };
          value = cfg.settings;
        };
      };
  };
}
