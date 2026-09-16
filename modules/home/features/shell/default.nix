{ self, ... }: {
  flake.homeModules.shell =
    {
      osConfig,
      #lib,
      #options,
      ...
    }:
    let
      #capitalize = s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (-1) s;
      shell = osConfig.preferences.shell;
      #integrationOption = "enable${capitalize shell}Integration";
      #enableIntegration = program: { "${integrationOption}" = true; };
      #hasOption = program: lib.hasAttrByPath [ "programs" program integrationOption ] options;
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
        #// lib.optionalAttrs (hasOption "lsd") (enableIntegration "lsd");
        bat.enable = true;
        zoxide = {
          enable = true;
        };
        #// lib.optionalAttrs (hasOption "zoxide") (enableIntegration "zoxide");
        fd.enable = true;
        btop.enable = true;
        yazi = {
          enable = true;
        };
        lazygit.enable = true;
        fastfetch.enable = true;
      };
      preferences.persistance.cache.directories = [
        ".cache/tealdeer/tldr-pages"
      ];
    };
}
