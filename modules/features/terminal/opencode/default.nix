{
  flake.nixosModules.opencode = {
    config,
    lib,
    inputs,
    pkgs,
    ...
  }: let
    style = config.appearance;
  in {
    shell.packages.opencode = lib.mkIf (config.preferences.proxy != null) (
      inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.opencode;
        env = config.preferences.proxy.env;
      }
    );
    homefs.files = lib.mkIf (style.scheme != null) {
      ".config/opencode/themes/nix.json" = style.colors {src = ./nix.json.mustache;};
      ".config/opencode/tui.json" = {
        value = {
          theme = "nix";
        };
        generator = builtins.toJSON;
      };
    };
  };
}
