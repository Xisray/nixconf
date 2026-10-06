{
  flake.wrappers.bat = {
    wlib,
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];
    options = with lib; {
      themes = mkOption {
        type = types.attrsOf (types.either types.path types.lines);
        default = {};
      };
      settings = mkOption {
        type = types.lines;
        default = "";
      };
    };
    config = let
      configDir = pkgs.runCommand "bat-config" {} ''
        mkdir -p $out/themes
        cp ${pkgs.writeText "bat-config" config.settings} $out/config
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: theme: let
          src =
            if builtins.isPath theme || lib.isDerivation theme
            then theme
            else pkgs.writeText "${name}.tmTheme" theme;
        in "cp ${src} $out/themes/${lib.escapeShellArg name}.tmTheme")
        config.themes)}
      '';

      cacheDir = pkgs.runCommand "bat-cache" {nativeBuildInputs = [config.package];} ''
        mkdir -p $out
        bat cache --build --source ${configDir} --target $out
      '';
    in {
      package = lib.mkDefault pkgs.bat;
      env = {
        BAT_CONFIG_DIR = "${configDir}";
        BAT_CONFIG_PATH = "${configDir}/config";
        BAT_CACHE_PATH = "${cacheDir}";
      };
    };
  };
}
