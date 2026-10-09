{self, ...}: {
  flake.shellModules.bat = {
    lib,
    appearance,
    pkgs,
    ...
  }: let
    variant =
      if appearance.base24
      then "base24"
      else "base16";
    bat = self.wrappers.bat or null;
    hasScheme = appearance.scheme != null;
  in {
    packages.bat = lib.mkIf (bat != null && hasScheme) (
      bat.wrap {
        inherit pkgs;
        themes.${variant} = appearance.colors {
          template = ./${variant}.tmTheme.mustache;
          extension = ".tmTheme";
        };
        settings = ''
          --theme="${variant}"
        '';
      }
    );
  };
}
