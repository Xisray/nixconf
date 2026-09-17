{ self, ... }: {
  flake.homeModules.shell =
    {
      osConfig,
      lib,
      ...
    }:
    let
      shell = osConfig.preferences.shell;
    in
    {
      imports =
        if builtins.hasAttr shell self.homeModules then
          [
            self.homeModules.${shell}
          ]
        else
          [ ];
      programs = {
        ${shell} = {
          enable = true;
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
        };
        tealdeer.enable = true;
        fzf = {
          enable = true;
        };
        ripgrep.enable = true;
        lsd = {
          enable = true;
        };
        bat.enable = true;
        zoxide = {
          enable = true;
        };
        fd.enable = true;
        btop.enable = true;
        yazi = {
          enable = true;
          theme = {
            mode.normal_alt.bg = lib.mkForce osConfig.lib.stylix.colors.withHashtag.base02;
          };
        };
        lazygit.enable = true;
        fastfetch.enable = true;
      };
      preferences.persistance.cache.directories = [
        ".cache/tealdeer/tldr-pages"
      ];
    };
}
