{ ... }: {
  flake.homeModules.shell = {
    programs = {
      fzf = {
        enable = true;
      };
      ripgrep.enable = true;
      lsd.enable = true;
      bat.enable = true;
      zoxide.enable = true;
      fd.enable = true;
      btop.enable = true;
      yazi = {
        enable = true;
      };
    };
  };
}
