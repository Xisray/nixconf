{ inputs, ... }: {
  flake.nixosModules.noctaliaGreeter = { config, ... }: {
    imports = [
      inputs.noctalia-greeter.nixosModules.default
    ];
    programs.noctalia-greeter = {
      enable = true;
      settings = {
        session.defafult = "niri";
        user.default = config.preferences.user.name;
      };
    };
  };
}
