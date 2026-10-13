{self, ...}: {
  flake.shellModules.bat = {
    lib,
    appearance,
    pkgs,
    ...
  }: let
    bat = self.wrappers.bat or null;
    hasScheme = appearance.scheme != null;
  in {
    packages.bat = lib.mkIf (bat != null && hasScheme) (
      bat.wrap {
        inherit pkgs;
        themes.nix = appearance.colors {
          src = ./bat.tmTheme.mustache;
        };
        settings = ''
          --theme="nix"
        '';
      }
    );
  };
}
