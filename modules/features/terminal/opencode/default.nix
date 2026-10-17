{inputs, ...}: {
  flake.shellModules.opencode = {
    module = {
      lib,
      appearance,
      pkgs,
      ...
    }: {
      packages.opencode = inputs.wrappers.wrapperModules.opencode.wrap {
        inherit pkgs;
        tui-settings = lib.optionalAttrs (appearance.scheme != null) {
          theme = "nix";
        };
      };
    };
    nixos = {
      lib,
      config,
      ...
    }: let
      theme =
        if (config.appearance == null)
        then null
        else (config.appearance.colors {src = ./nix.json.mustache;});
    in {
      systemd.user.tmpfiles.rules = lib.mkIf (theme != null) [
        "L+ %h/.config/opencode/themes/nix.json - - - - ${theme}"
      ];
    };
  };
}
