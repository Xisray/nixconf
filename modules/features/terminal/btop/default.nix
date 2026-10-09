{self, ...}: {
  flake.shellModules.btop = {
    pkgs,
    wlib,
    lib,
    appearance,
    ...
  }: let
    variant =
      if appearance.base24
      then "base24"
      else "base16";
    btop = self.wrappers.btop or (wlib.wrapModule wlib.wrapperModules.btop);
    hasScheme = appearance.scheme != null;
    flat = appearance.rounding == 0;
  in {
    packages.btop = lib.mkIf (hasScheme || flat) (
      btop.wrap {
        inherit pkgs;
        themes.${variant} = lib.mkIf hasScheme (appearance.colors {
          template = ./${variant}.theme.mustache;
          extension = ".theme";
        });
        settings.color_theme = lib.mkIf hasScheme (lib.mkForce variant);
        settings.rounded_corners = lib.mkIf flat (lib.mkForce false);
      }
    );
  };
}
