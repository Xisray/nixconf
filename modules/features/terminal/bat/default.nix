{self, ...}: {
  flake.shellModules.bat = {
    pkgs,
    lib,
    appearance,
    ...
  }: let
    variant =
      if appearance.base24
      then "base24"
      else "base16";
    bat = self.packages.${pkgs.stdenv.hostPlatform.system}.bat or null;
    hasScheme = appearance.scheme != null;
  in {
    packages.bat = lib.mkIf (bat != null && hasScheme) (
      bat.wrap {
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
