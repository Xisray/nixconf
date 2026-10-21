{
  self,
  lib,
  ...
}: let
  shellModuleEntry = lib.types.submodule {
    options = {
      module = lib.mkOption {
        type = lib.types.deferredModule;
        default = {};
        description = "Module imported into the wrapped shell (packages, settings, …)";
      };
      nixos = lib.mkOption {
        type = lib.types.nullOr lib.types.deferredModule;
        default = null;
        description = "Optional NixOS module merged into flake.nixosModules.shell";
      };
    };
  };
  normalizeShellModule = value:
    if builtins.isAttrs value && value ? module
    then {
      module = value.module;
      nixos = value.nixos or null;
    }
    else {
      module = value;
      nixos = null;
    };
in {
  options.flake.shellModules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.coercedTo lib.types.raw normalizeShellModule shellModuleEntry);
    default = {};
  };
  config.flake.nixosModules.shell = {
    config,
    lib,
    pkgs,
    ...
  }: let
    user = config.preferences.user;
    entries = lib.attrValues self.shellModules;
    shellEval = self.wrappers.${user.shell}.eval {
      inherit pkgs;
      imports = map (e: e.module) entries;
      _module.args.appearance = config.appearance;
      _module.args.preferences = config.preferences;
    };
    shell = shellEval.config.wrapper;
    # shell = self.wrappers.${user.shell}.wrap {
    #   inherit pkgs;
    #   imports = map (e: e.module) entries;
    #   _module.args.appearance = config.appearance;
    # };
  in {
    imports = lib.filter (m: m != null) (map (e: e.nixos) entries);
    _module.args.shellPackages = shellEval.config.packages;
    users.users.${user.name}.shell = shell;
    programs.${user.shell} = {
      enable = true;
      package = shell;
    };
    preferences.user.packages = [pkgs.ffmpeg];
    preferences.persistence = {
      data.directories = [
        ".local/state/lazygit"
        ".local/share/devenv"
        ".local/share/zoxide"
      ];
      cache.directories = [
        ".cache/nix"
        ".cache/tealdeer/tldr-pages"
      ];
    };
  };
}
