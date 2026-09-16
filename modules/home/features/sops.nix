{ self, inputs, ... }: {
  flake.homeModules.sops = { config, ... }: {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
    sops = {
      defaultSopsFile = "${self}/secrets/secrets.yaml";

      age.keyFile = "/persist/userdata${config.home.homeDirectory}/.config/sops/age/keys.txt";

      # secrets.yandex_music_token = { };
    };
    preferences.persistance.data.directories = [
      ".config/sops"
    ];
  };
}
