{ self, inputs, ... }: {
  flake.homeModules.sops = { config, ... }: {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
    sops = {
      defaultSopsFile = "${self}/secrets/secrets.yaml";

      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      # secrets.yandex_music_token = { };
    };
    preferences.persistance.data.files = [
      ".config/sops/age/keys.txt"
    ];
  };
}
