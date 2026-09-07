{ self, ... }: {
  flake.homeModules.preferences = { lib, ... }: {
    imports = [
      self.sharedModules.preferences
    ];
    options.preferences = {
      shell = lib.mkOption {
        type = lib.types.enum [
          "fish"
          "zsh"
          "bash"
        ];
        default = "bash";
      };
    };
  };
}
