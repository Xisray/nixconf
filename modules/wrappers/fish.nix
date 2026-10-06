{self, ...}: {
  flake.wrappers.fish = {
    wlib,
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.fish];
    options = let
      mkPackageOption = name:
        lib.mkOption {
          type = lib.types.package;
          default = self.packages.${pkgs.stdenv.hostPlatform.system}.${name} or pkgs.${name} or (throw "Package '${name}' not found in self.packages.${pkgs.stdenv.hostPlatform.system} or pkgs!");
          description = "Package for ${name}";
        };
      packageNames = ["tealdeer" "fzf" "ripgrep" "lsd" "fd" "btop" "fastfetch" "bat" "zoxide" "devenv" "wl-clipboard" "jq" "lazygit" "git" "neovim" "starship" "yazi"];
    in {
      packages = lib.genAttrs packageNames mkPackageOption;
    };
    config = {
      runtimePkgs = builtins.attrValues config.packages;
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
      env = {
        EDITOR = lib.getExe config.packages.neovim;
      };
      configFile.content = ''
        starship init fish | source
        zoxide init fish --cmd cd | source
        fzf --fish | source
        if test -f /etc/fish/nixos-env-preinit.fish
          source /etc/fish/nixos-env-preinit.fish
        end
        source ~/.config/fish/config.fish
        if test -d ~/.config/fish/conf.d
          for f in ~/.config/fish/conf.d/*.fish
            source $f
          end
        end
      '';
    };
  };
}
