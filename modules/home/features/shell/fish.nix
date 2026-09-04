{
  flake.homeModules.fish = {
    programs.fish = {
      functions.nswitch.body = ''
        if set -q argv[1]
          sudo nixos-rebuild switch --flake $HOME/nixconf\#$argv[1]
        else
          sudo nixos-rebuild switch --flake "$HOME/nixconf"
        end
      '';
    };
  };
}
