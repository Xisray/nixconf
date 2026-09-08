{ inputs, ... }: {
  flake.nixosModules.wallpapers =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      colors = builtins.attrValues config.lib.stylix.colors.withHashtag;
      hald-clut =
        pkgs.runCommand "stylix-hald-clut.png"
          {
            nativeBuildInputs = [ pkgs.lutgen ];
          }
          ''
            lutgen generate -o $out -- ${lib.escapeShellArgs colors}
          '';
      wallpapers = pkgs.stdenvNoCC.mkDerivation {
        pname = "wallpapers";
        version = inputs.wallpapers.rev or "unknown";
        src = inputs.wallpapers;
        nativeBuildInputs = [ pkgs.lutgen ];
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
