{
  self,
  lib,
  ...
}: {
  options.flake.shellModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = {};
  };
  config.flake.nixosModules.shell = {
    config,
    lib,
    pkgs,
    ...
  }: let
    user = config.preferences.user;
    shell = self.packages.${pkgs.stdenv.hostPlatform.system}.${user.shell}.wrap {
      imports = lib.attrValues self.shellModules;
      _module.args.appearance = config.appearance;
    };
  in {
    users.users.${user.name}.shell = shell;
    programs.${user.shell} = {
      enable = true;
      package = shell;
    };
    preferences.persistence.data.directories = [
      ".local/state/lazygit"
      ".config/fzf/themes"
    ];
  };
}
