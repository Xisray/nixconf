{
  flake.nixosModules.preferences = {
    lib,
    config,
    ...
  }: {
    options.preferences.proxy = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule (
          {config, ...}: {
            options = {
              http = lib.mkOption {type = lib.types.str;};
              https = lib.mkOption {type = lib.types.str;};
              all = lib.mkOption {type = lib.types.str;};
              no = lib.mkOption {
                type = lib.types.str;
                default = "localhost,127.0.0.1";
              };
              env = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                readOnly = true;
                internal = true;
                description = "Готовый attrset для environment variables";
                default = {
                  http_proxy = config.http;
                  https_proxy = config.https;
                  all_proxy = config.all;
                  no_proxy = config.no;
                };
              };
            };
          }
        )
      );
      default = null;
    };
  };
}
