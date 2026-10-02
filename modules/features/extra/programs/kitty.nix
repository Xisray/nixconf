{
  flake.hjemExtraModules.programs =
    {
      lib,
      pkgs,
      config,
      osConfig,
      ...
    }:
    let
      toKittyConf = pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault {
          mkValueString =
            v: if lib.isBool v then (if v then "yes" else "no") else lib.generators.mkValueStringDefault { } v;
        } " ";
      };
    in
    {
      options.programs.kitty =
        let
          mkShellIntegrationOption =
            shell:
            lib.mkOption {
              type = lib.types.bool;
              default = osConfig.programs.${shell}.enable;
            };
        in
        {
          enable = lib.mkEnableOption "kitty";
          package = lib.mkPackageOption pkgs "kitty" { nullable = true; };
          includes = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
          settings = lib.mkOption {
            type = toKittyConf.type;
            default = { };
          };
          integration = {
            fish.enable = mkShellIntegrationOption "fish";
          };
        };
      config =
        let
          cfg = config.programs.kitty;
        in
        lib.mkIf cfg.enable {
          packages = lib.optional (cfg.package != null) cfg.package;
          xdg.config.files."kitty/kitty.conf".source =
            let
              hasIntegration = cfg.integration.fish.enable;
              settings =
                cfg.settings
                // lib.optionalAttrs (cfg.includes != [ ]) { include = cfg.includes; }
                // lib.optionalAttrs hasIntegration { shell_integration = "no_rc"; };
            in
            lib.mkIf (settings != { }) toKittyConf.generate "kitty.conf" settings;
          shell.fish.interactiveInit = ''
            if set -q KITTY_INSTALLATION_DIR
              set --global KITTY_SHELL_INTEGRATION "no_rc"
              source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
              set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
            end
          '';
        };
    };
}
