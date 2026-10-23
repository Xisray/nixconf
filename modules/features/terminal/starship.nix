{self, ...}: {
  flake.shellModules.starship = {
    appearance,
    lib,
    pkgs,
    ...
  }: let
    starship = self.wrappers.starship or null;
  in {
    packages.starship = lib.mkIf (starship != null) (starship.wrap {
      inherit pkgs;
      colors = lib.mkIf (appearance.scheme != null) (with appearance.colors.withHashtag; {
        primary = primary;
        base = base00;
        peach = base09;
        lavender = base07;
        flamingo = base0F;
      });
      rounded = appearance.rounding > 0;
      type = "modern";
      frame = true;
    });
  };
}
