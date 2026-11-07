{
  flake.nixosModules.prismlauncher = {pkgs, ...}: {
    users.packages = [
      pkgs.prismlauncher
    ];
  };
}
