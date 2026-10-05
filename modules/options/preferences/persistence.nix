{
  flake.nixosModules.preferences = {lib, ...}: let
    listOfAny = description:
      lib.mkOption {
        default = [];
        description = description;
      };
  in {
    options.preferences.persistence = with lib; {
      nukeRoot.enable = mkEnableOption "Destroy /root on every boot";
      volumeGroup = mkOption {
        default = "btrfs_vg";
        description = "Btrfs volume group name";
      };
      directories = listOfAny "System directories to persist";
      files = listOfAny "System files to persist";
      data = {
        directories = listOfAny "Persistent user data directories";
        files = listOfAny "Persistent user data files";
      };
      cache = {
        directories = listOfAny "Persistent cache directories";
        files = listOfAny "Persistent cache files";
      };
    };
  };
}
