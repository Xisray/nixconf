{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrappers = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    palette.url = "github:xisray/palette.nix";

    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv";

    # cliamp.url = "github:bjarneo/cliamp";
    # opencode = {
    #   url = "github:anomalyco/opencode";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.disko.flakeModules.default
        inputs.wrappers.flakeModules.wrappers
        inputs.flake-parts.flakeModules.modules
        inputs.devenv.flakeModule
        (inputs.import-tree ./modules)
        # ./hosts
      ];
    };
}
