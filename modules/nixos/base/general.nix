{ self, ... }: {
  flake.nixosModules.general = { pkgs, config, ... }: {
    imports = [
      self.nixosModules.audio
      self.nixosModules.fonts
    ];
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    networking = {
      hostName = config.preferences.hostName;
      networkmanager.enable = true;
    };
    time.timeZone = "Asia/Yekaterinburg";

    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;

      hashedPasswordFile = "/persist/passwd";
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    preferences.persistance.data.directories = [
      "nixconf"

      "Downloads"
      "Documents"
      "Projects"
      "Pictures"

      ".ssh"
    ];
    nix.settings = {
      substituters = [
        "https://cache.m7.rs"
        "https://cache.nixos.org"
        "https://cache.soopy.moe"
        "https://chaotic-nyx.cachix.org"
        "https://colmena.cachix.org"
        "https://hyprland.cachix.org"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://nixos-cache-proxy.cofob.dev"
        "https://nixos.snix.store"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      connect-timeout = 5;
      download-attempts = 3;
      fallback = true;
      http-connections = 16;
      stalled-download-timeout = 30;
    };
  };
}
