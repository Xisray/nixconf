{moduleWithSystem, ...}: {
  flake.nixosModules.mpv = moduleWithSystem ({self', ...}: {pkgs, ...}: {
    user.packages = [(self'.packages.mpv or pkgs.mpv)];
    # preferences = {
    #   persistence.cache.directories = [
    #     ".cache/keepassxc"
    #   ];
    # };
  });
}
