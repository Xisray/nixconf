{self, ...}: {
  flake.shellModules.btop = {
    pkgs,
    lib,
    appearance,
    ...
  }: let
    btop = self.wrappers.btop or null;
    hasScheme = appearance.scheme != null;
    flat = appearance.rounding == 0;
  in {
    packages.btop = lib.mkIf (btop != null && (hasScheme || flat)) (
      btop.wrap {
        inherit pkgs;
        themes.nix = lib.mkIf hasScheme (appearance.colors {
          src = ./btop.theme.mustache;
        });
        settings.color_theme = lib.mkIf hasScheme (lib.mkForce "nix");
        settings.rounded_corners = lib.mkIf flat (lib.mkForce false);
      }
    );
  };
}
