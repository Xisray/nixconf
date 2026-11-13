{moduleWithSystem, ...}: {
  flake.nixosModules.mpv = moduleWithSystem ({self', ...}: {pkgs, ...}: {
    user.packages = [(self'.packages.mpv or pkgs.mpv)];
    appearance.targets.mpv = {
      enable = true;
      modernzEnable = true;
    };
    preferences.persistence.cache.directories = [
      ".cache/mpv"
    ];
  });
}
