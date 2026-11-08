{
  flake.nixosModules.appearance = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.appearance;
    wallCfg = cfg.wallpapers;
  in {
    options.appearance.wallpapers = {
      source = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
      algorithm = lib.mkOption {
        type = lib.types.enum ["gaussian-rbf" "shepards-method" "nearest-neighbor"];
        default = "gaussian-rbf";
      };
      level = lib.mkOption {
        type = lib.types.ints.between 2 16;
        default = 10;
      };
      preserveLuminosity = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      luminosityFactor = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
      };
      final = {
        source = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          readOnly = true;
        };
        path = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          readOnly = true;
        };
      };
    };
    config = {
      appearance.wallpapers.final =
        if (cfg.hasScheme && cfg.wallpapers.source != null)
        then
          (let
            colors = map (n: cfg.colors.withHashtag.${n}) (map (d: "base0${d}") (lib.stringToCharacters "0123456789ABCDEF"));
            algorithmFlag =
              {
                gaussian-rbf = "-R";
                shepards-method = "-S";
                nearest-neighbor = "-N";
              }.${
                wallCfg.algorithm
              };
            lutgenGenerateArgs =
              [algorithmFlag "-l" (toString wallCfg.level) "-L" (toString wallCfg.luminosityFactor)]
              ++ lib.optional wallCfg.preserveLuminosity "-P";

            lut = pkgs.runCommand "wallpaper-lut" {nativeBuildInputs = [pkgs.lutgen];} ''
              lutgen generate -o lut.png ${lib.escapeShellArgs lutgenGenerateArgs} -- ${lib.escapeShellArgs colors}
              mv lut.png $out
            '';
            wallpapers = pkgs.runCommand "wallpapers" {nativeBuildInputs = [pkgs.lutgen];} ''
              shopt -s nullglob nocaseglob
              mkdir -p $out
              for f in ${wallCfg.source}/*.{png,jpg,jpeg,webp}; do
                lutgen apply --hald-clut ${lut} -o "$out/$(basename "$f")" "$f"
              done
            '';
          in {
            source = wallpapers;
            path = "/etc/wallpapers";
          })
        else {
          source = null;
          path = null;
        };
      environment.etc."wallpapers" = lib.mkIf (wallCfg.final.source != null) {source = wallCfg.final.source;};
    };
  };
}
