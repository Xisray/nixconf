{
  flake.nixosModules.prismlauncher = {pkgs, ...}: {
    user.packages = [
      pkgs.prismlauncher
    ];
    appearance.targets.prismlauncher.enable = true;

    preferences.persistence.data.directories = [
      ".local/share/PrismLauncher"
    ];
  };
}
