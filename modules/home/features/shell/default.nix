{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.shell = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.${self.selectedApps.shell};
      runtimePkgs = with pkgs; [
        fzf
        ripgrep
        lsd
        bat
        zoxide
        fd
        btop
        yazi
      ];
    };
  };
}
