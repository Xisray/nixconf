{self, ...}: {
  flake.nixosModules.shell = {
    config,
    pkgs,
    lib,
    ...
  }: let
    user = config.preferences.user;
    shellWrapper = self.wrappers.${user.shell} or null;
    shell =
      if (shellWrapper == null || config.shell.packages == {})
      then self.packages.${pkgs.stdenv.hostPlatform.system}.${user.shell} or pkgs.${user.shell}
      else
        shellWrapper.wrap {
          inherit pkgs;
          packages = config.shell.packages;
        };
  in {
    imports = [
      self.nixosModules.yazi
      self.nixosModules.bat
      self.nixosModules.btop
      self.nixosModules.opencode
      self.nixosModules.devenv
      # self.nixosModules.fastfetch
      self.nixosModules.fzf
      self.nixosModules.lazygit
      self.nixosModules.nvim
      self.nixosModules.starship
    ];
    options.shell.packages = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = {};
    };
    config = {
      users.users.${user.name}.shell = "/run/current-system/sw/bin/${user.shell}";
      programs.${user.shell} = {
        enable = true;
        package = shell;
      };
      preferences.persistence = {
        data.directories = [".local/share/zoxide"];
        cache.directories = [".cache/tealdeer/tldr-pages"];
      };
    };
  };
}
