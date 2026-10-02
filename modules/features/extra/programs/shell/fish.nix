{
  flake.hjemExtraModules.programs =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    {
      options.shell.fish = {
        init = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Shell script code called during fish shell
            initialisation.
          '';
        };
        loginInit = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Shell script code called during fish login shell
            initialisation.
          '';
        };
        interactiveInit = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Shell script code called during interactive fish shell
            initialisation.
          '';
        };
      };
      config =
        let
          cfg = config.shell.fish;
        in
        lib.mkIf osConfig.programs.fish.enable {
          xdg.config.files."fish/config.fish".text = ''
            ${cfg.init}
            status is-login; and begin
              ${cfg.loginInit}
            end
            status is-interactive; and begin
              ${cfg.interactiveInit}
            end
          '';
        };
    };
}
