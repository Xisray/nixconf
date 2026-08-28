{ self, inputs, ... }: {
  flake.nixosModules.clashVerge = { pkgs, lib, ... }: {
    programs.clash-verge = {
      enable = true;
      autoStart = false;
      serviceMode = true;
      tunMode = true;
    };

    preferences.persistance.cache.directories = [
      ".cache/io.github.clash-verge-rev.clash-verge-rev"
    ];
  };
}
