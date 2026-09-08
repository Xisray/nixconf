{ inputs, ... }: {
  flake.nixosModules.wallpapers =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      colors = with config.lib.stylix.colors.withHashtag; [
        base00
        base01
        base02
        base03
        base04
        base05
        base06
        base07
        base08
        base09
        base0A
        base0B
        base0C
        base0D
        base0E
        base0F
      ];
      hald-clut =
        pkgs.runCommand "stylix-hald-clut.png"
          {
            nativeBuildInputs = [ pkgs.lutgen ];
            inherit (config.stylix) base16Scheme;
          }
          ''
            lutgen generate -o $out -- ${lib.escapeShellArgs colors}
          '';
      wallpapers = pkgs.stdenvNoCC.mkDerivation {
        pname = "wallpapers";
        version = inputs.wallpapers.rev or "unknown";
        src = inputs.wallpapers;
        nativeBuildInputs = [ pkgs.lutgen ];
        inherit (config.stylix) base16Scheme;
        installPhase = ''
          mkdir -p $out
          for f in "$src"/*.{png,jpg,jpeg,webp}; do
            [ -e "$f" ] || continue
          	lutgen apply --hald-clut ${hald-clut} "$f" -o "$out/$(basename "$f")"
          done
        '';
      };
    in
    {
      environment.etc."wallpapers".source = wallpapers;

      preferences.persistance.directories = [
        "/etc/wallpapers"
      ];
    };
}
