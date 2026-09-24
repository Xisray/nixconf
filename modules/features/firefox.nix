{ self, ... }: {
  flake.nixosModules.firefox = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.firefox
    ];
    preferences = {
      wm.rules.windows = [
        {
          match.title = "^(Picture-in-Picture|Картинка в картинке)$";
          open-floating = true;
        }
      ];
      persistence = {
        data.directories = [
          ".mozilla"
          ".config/mozilla"
        ];
        cache.directories = [
          ".cache/mozilla"
        ];
      };
    };
  };
}
