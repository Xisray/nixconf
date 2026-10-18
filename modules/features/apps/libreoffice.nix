{
  flake.nixosModules.libreoffice = {pkgs, ...}: {
    user.packages = [pkgs.libreoffice-qt];
    preferences.persistence.data.directories = [
      ".config/libreoffice"
    ];
  };
}
