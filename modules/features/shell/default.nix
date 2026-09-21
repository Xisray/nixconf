{
  inputs,
  config,
  pkgs,
  ...
}:
let
  user = config.preferences.user;
in
{
  users.users.${user.name}.shell = pkgs.${user.shell};
  programs = {
    ${user.shell} = {
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
    bat.enable = true;
    zoxide = {
      enable = true;
      flags = [ "--cmd cd" ];
    };
  };
  perSystem = { pkgs, ... }: {
    packages.${user.shell} = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.${user.shell};
      runtimePkgs = [
        pkgs.tealdeer
        pkgs.fzf
        pkgs.ripgrep
        pkgs.lsd
        pkgs.fd
        pkgs.btop
        pkgs.fastfetch
        pkgs.devenv
      ];
    };
  };
}
