{ self, ... }: {
  flake.wrappers.fish =
    {
      lib,
      wlib,
      pkgs,
      ...
    }:
    let
      self' = self.packages.${pkgs.stdenv.hostPlatform.system}; 
      git = self'.git or pkgs.git;
      neovim = self'.neovim or pkgs.neovim;
      starship = self'.starship or pkgs.starship;
      lazygit = self'.lazygit or pkgs.lazygit;
    in
    {
      imports = [ wlib.wrapperModules.fish ];
      shellAliases = {
        vim = "nvim";
        vi = "nvim";
        ls = "lsd";
        la = "ls -a";
        ll = "ls -l";
        lla = "ls -la";
        lt = "ls --tree";
        lta = "ls --tree -a";
        ltl = "ls --tree -l";
        ltla = "ls --tree -la";
        lg = "lazygit";
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
        pkgs.wl-clipboard
        lazygit
        git
        neovim
        starship
      ];
      env = {
        EDITOR = lib.getExe neovim;
      };
      configFile.content = ''
        starship init fish | source
        zoxide init fish --cmd cd | source
        fzf --fish | source
        source ~/.config/fish/config.fish
      '';
    };
}
