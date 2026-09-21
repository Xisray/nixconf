{ lib, config, ... }: {
  options.flake.terminals = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          wrap = lib.mkOption { type = lib.types.functionTo lib.types.package; };
          args = lib.mkOption { type = lib.types.attrs; };
        };
      }
    );
    default = { };
  };
  perSystem = {
    packages = lib.mapAttrs (name: def: def.wrap def.args) config.flake.terminals;
  };
}
