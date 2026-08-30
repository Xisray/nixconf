{ self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.terminal = pkgs.${self.selectedApps.terminal};
  };
}
