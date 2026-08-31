{ self, ... }: {
  flake.homeModules.shell =
    { config, ... }:
    let
      shell = config.preferences.shell;
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
            ls = "lsd";
            ll = "ls -l";
            la = "ls -a";
            lla = "ls -la";
            lt = "ls --tree";
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
