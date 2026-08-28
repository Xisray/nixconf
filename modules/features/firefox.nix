{ self, inputs, ... }: {
  flake.nixosModules.firefox = { pkgs, lib, ... }: {
    programs.firefox = {
      enable = true;
      policies = {
      };
    };

    preferences.persistance.data.directories = [
      ".mozilla"
    ];

    preferences.persistance.cache.directories = [
      ".cache/mozilla"
    ];
  };
}
