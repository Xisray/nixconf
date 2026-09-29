{
  flake.nixosModules.nix = {config, ...}: {
    programs.nh = {
      enable = true;
      flake = "/home/${config.preferences.user.name}/nixconf";
      clean = {
        enable = true;
        dates = "Mon *-*-* 09:00:00";
        extraArgs = "--keep 3 --keep-since 5d";
      };
    };
    preferences.persistence.data.directories = [
      "nixconf"
    ];
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # keep-outputs = true;
      # keep-derivations = true;

      trusted-users = ["root" "@wheel"];

      substituters = [
        "https://cache.nixos.org"

        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://chaotic-nyx.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://colmena.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      ];
      # auto-optimise-store = true;
      builders-use-substitutes = true;
      connect-timeout = 5;
      download-attempts = 3;
      fallback = true;
      http-connections = 16;
      stalled-download-timeout = 30;
    };
    nix.optimise = {
      automatic = true;
      dates = ["09:00:00"];
    };
  };
}
