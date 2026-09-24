{
  flake.wrappers.fish =
    {
      lib,
      wlib,
      pkgs,
      self',
      ...
    }:
    {
      imports = [ wlib.wrapperModules.fish ];
      shellAliases = {
        man = "tldr";
        grep = "rg";
        cat = "bat --paging=never";
        top = "btop";
        y = "yazi";
        ".." = "cd ..";
        v = "nvim";
        g = "git";
        gst = "git status";
        gl = "git pull";
        gp = "git push";
        gc = "git commit -v";
        "gc!" = "git commit -v --ammend";
        gca = "git commit -v -a";
        "gca!" = "git commit -v -a --ammend";
        gcmsg = "git commit -m";
      };
      runtimePkgs = [
        pkgs.tealdeer
        pkgs.fzf
        pkgs.ripgrep
        pkgs.lsd
        pkgs.fd
        pkgs.btop
        pkgs.fastfetch
        pkgs.bat
        pkgs.zoxide
        pkgs.devenv
        (self'.packages.git or pkgs.git)
        (self'.packages.neovim or pkgs.neovim)
      ];
      env = {
        EDITOR = lib.getExe (self'.packages.neovim or pkgs.neovim);
      };
      configFile.content = ''
        zoxide init fish --cmd cd | source
      '';
    };
}
