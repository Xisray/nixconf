{
  flake.wrappers.neovim = { pkgs, lib, config, ... }:
  let 
    typeOrListOfType = type: lib.types.either type (lib.types.listOf type);
    rootMarkersType = lib.types.either lib.types.str (lib.types.listOf (typeOrListOfType lib.types.str));

    languageType = lib.types.submodule {
      freeformType = lib.types.attrsOf lib.types.anything;
      options = {
        cmd = lib.mkOption { type = typeOrListOfType lib.types.str; default = [ ]; };
        packages = lib.mkOption { type = typeOrListOfType lib.types.package; default = [ ]; };
        filetypes = lib.mkOption { type = typeOrListOfType lib.types.str; default = [ ]; };
        root_markers = lib.mkOption { type = rootMarkersType; default = [ ]; };
        extra_config = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
      };
    };
  
  metaKeys = [ "packages" "extra_config" ];
  mkLspConfig = name: lang:
    let
      raw = removeAttrs lang metaKeys;
      normalized = raw // {
        cmd = lib.toList raw.cmd;
        filetypes = lib.toList raw.filetypes;
        root_markers = lib.toList raw.root_markers;
      };
      nonEmpty = lib.filterAttrs (_: v: v != [ ] && v != null) normalized;
    in
    ''
      ${lib.optionalString (nonEmpty != { }) ''
        vim.lsp.config["${name}"] = ${lib.generators.toLua { } nonEmpty}
      ''}${lib.optionalString (lang.extra_config != null) "${lang.extra_config}\n"}vim.lsp.enable("${name}")
    '';
  in {
    options.languages = lib.mkOption {
      type = lib.types.attrsOf languageType;
      default = { };
    };
    config = 
    let
      cfg = config.languages;
    in {
      extraPackages = lib.flatten (lib.mapAttrsToList (_: lang: lib.toList lang.packages) cfg);
      
      specs = lib.mapAttrs (name: lang: {
        data = [ pkgs.vimPlugins.nvim-lspconfig ];
        config = mkLspConfig name lang;
      }) cfg;
    };
  };
}
