{ self, ... }: {
  flake.wrappers.fish =
    {
      lib,
      wlib,
      pkgs,
      ...
    }:
    let
      git = self.packages.${pkgs.stdenv.hostPlatform.system}.git or pkgs.git;
      neovim = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim or pkgs.neovim;
    in
    {
      imports = [ wlib.wrapperModules.fish ];
      shellAliases = {
        vim = "nvim";
        vi = "nvim";
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
	pkgs.yazi
        git
        neovim
      ];
      env = {
        EDITOR = lib.getExe neovim;
      };
      configFile.content = ''
        zoxide init fish --cmd cd | source
      '';
    };
}
