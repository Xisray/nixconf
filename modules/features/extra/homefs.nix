{
  flake.nixosModules.homefs = {
    lib,
    config,
    pkgs,
    ...
  }: let
    moduleName = "homefs";
  in {
    options.${moduleName} = let
      mkNullableOption = type:
        lib.mkOption {
          type = lib.types.nullOr type;
          default = null;
        };
      fileModule = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          value = mkNullableOption lib.types.anything;
          generator = mkNullableOption (lib.types.functionTo lib.types.raw);
          text = mkNullableOption lib.types.lines;
          source = mkNullableOption lib.types.path;
        };
      };
      fileType = lib.types.coercedTo lib.types.path (source: {inherit source;}) fileModule;
      dirNode = lib.types.submodule {
        options = {
          files = lib.mkOption {
            type = lib.types.attrsOf fileType;
            default = {};
          };
          directories = lib.mkOption {
            type = lib.types.attrsOf dirNode;
            default = {};
          };
        };
      };
    in
      lib.mkOption {
        type = dirNode;
        default = {};
      };
    config = let
      cfg = config.${moduleName};
      link = dst: src: "L+ %h/${dst} - - - - ${src}";
      normalize = p: let
        parts = lib.filter (s: s != "") (lib.splitString "/" p);
      in
        if lib.elem ".." parts
        then throw "${moduleName}: path must not contain '..': ${p}"
        else lib.concatStringsSep "/" parts;

      join = a: b: normalize "${a}/${b}";

      flattenNode = prefix: node:
        (lib.mapAttrsToList (k: v: lib.nameValuePair (join prefix k) v) node.files)
        ++ lib.concatLists (
          lib.mapAttrsToList (k: sub: flattenNode (join prefix k) sub) node.directories
        );
      pairs = flattenNode "" cfg;
      flatFiles = lib.listToAttrs pairs;
      resolveSource = name: f: let
        g =
          if (f.source == null && f.value != null && f.generator != null)
          then f.generator f.value
          else null;
        fileName = baseNameOf name;
      in
        if f.source != null
        then f.source
        else if (g != null && builtins.isString g)
        then
          pkgs.writeText fileName (
            g + lib.optionalString (f.text != null) ((lib.optionalString (!lib.hasSuffix "\n" g) "\n") + f.text)
          )
        else if (g != null && (lib.isDerivation g || lib.isPath g))
        then g
        else if f.text != null
        then pkgs.writeText fileName f.text
        else null;
      resolved = lib.filterAttrs (_: src: src != null) (
        lib.mapAttrs resolveSource (lib.filterAttrs (_: f: f.enable) flatFiles)
      );
      addRules = lib.mapAttrsToList link resolved;
      manifest = pkgs.writeText "${moduleName}-manifest" (
        lib.concatMapStrings (dst: dst + "\n") (lib.attrNames resolved)
      );
      stateDir = ".local/state/${moduleName}";
    in {
      assertions = [
        {
          assertion = lib.length pairs == lib.length (lib.attrNames flatFiles);
          message = "${moduleName}: some file paths are declared more than once";
        }
      ];
      systemd.user.tmpfiles.rules = addRules ++ ["L+ %h/${stateDir}/manifest - - - - ${manifest}"];
      systemd.user.services."${moduleName}-cleanup" = {
        description = "Remove ${moduleName} links that are no longer declared";
        wantedBy = ["default.target"];
        before = ["systemd-tmpfiles-setup.service"];
        restartTriggers = [manifest];
        path = [
          pkgs.coreutils
          pkgs.gnugrep
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          old="$HOME/${stateDir}/manifest"
          [ -e "$old" ] || exit 0
          while IFS= read -r dst; do
            [ -n "$dst" ] || continue
            grep -qxF -- "$dst" ${manifest} && continue
            p="$HOME/$dst"
            if [ -L "$p" ] && [[ "$(readlink "$p")" == /nix/store/* ]]; then
              rm -f -- "$p"
            fi
          done < "$old"
        '';
      };
    };
  };
}
