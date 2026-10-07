{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.sops = {config, ...}: {
    imports = [
      inputs.sops.nixosModules.sops
    ];
    sops = let
      username = config.preferences.user.name;
    in {
      defaultSopsFile = "${self}/secrets/secrets.yaml";
      age.keyFile = "/persist/userdata/home/${username}/.config/sops/age/keys.txt";
      secrets = {
        gemini_api_key = {
          owner = username;
          group = "users";
          mode = "0400";
        };
        yandex_music_api_key = {
          owner = username;
          group = "users";
          mode = "0400";
        };
      };
    };
    preferences.persistence.data.directories = [
      ".config/sops"
    ];
  };
}
