{self, ...}: {
  flake.nixosModules.shell = {
    config,
    pkgs,
    lib,
    ...
  }: let
    user = config.preferences.user;
    theme = config.preferences.theme;
  in {
    users.users.${user.name}.shell = config.programs.${user.shell}.package;
    programs.${user.shell} = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.${user.shell} or pkgs.${user.shell};
    };
    preferences.persistence.data.directories = [
      ".local/state/lazygit"
      ".config/fzf/themes"
    ];
    home.xdg.config.files = {
      "fish/config.fish".text = "source ~/.config/fzf/themes/${theme.provider}.fish; or true";
      "btop/btop.conf" = {
        generator = let
          btopGenerator = lib.generators.toKeyValue {
            mkKeyValue = lib.generators.mkKeyValueDefault {
              mkValueString = v:
                if lib.isBool v
                then
                  (
                    if v
                    then "True"
                    else "False"
                  )
                else if lib.isString v
                then ''"${v}"''
                else lib.generators.mkValueStringDefault {} v;
            } " = ";
          };
        in
          btopGenerator;
        value = {
          color_theme = theme.provider;
          rounded_corners = theme.corner.radius > 0;
        };
      };
      "lazygit/custom.yml".text = lib.mkIf (theme.corner.radius == 0) ''
        gui:
          border: single
      '';
    };
  };
}
