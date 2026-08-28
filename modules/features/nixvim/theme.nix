{ self, inputs, ... }: {
  flake.nixosModules.nixvim = { pkgs, lib, ... }: {
    programs.nixvim.colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
      };
    };
  };
}
