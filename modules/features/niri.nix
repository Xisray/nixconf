{
  self,
  ...
}:
{
  flake.nixosModules.niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };

      home.files.".config/niri/config.kdl".text =
        let
          cfg = config.preferences;

          blur =
            if cfg.ui.blur.enable then
              ''
                blur {
                  passes 2
                  offset 3.0
                  noise 0.03
                  saturation 1.0
                }
              ''
            else
              "";
          mouse = ''
            input {
              mouse {
                ${lib.optionalString (
                  cfg.mouse.accelProfile != null
                ) ''accel-profile "${cfg.mouse.accelProfile}"''}
                ${lib.optionalString (
                  cfg.mouse.accelSpeed != null
                ) "accel-speed ${toString cfg.mouse.accelSpeed}"}
                ${lib.optionalString (
                  cfg.mouse.scrollFactor != null
                ) "scroll-factor ${toString cfg.mouse.scrollFactor}"}
                ${lib.optionalString cfg.mouse.naturalScroll "natural-scroll"}
              }
            }
          '';
          binds =
            let
              toArg = x: if lib.isDerivation x || lib.isPackage x then lib.getExe x else toString x;
              renderAction =
                action:
                let
                  isList = builtins.isList action;
                  args = if isList then action else [ action ];
                  rendered = map toArg args;
                in
                if isList then
                  "spawn ${lib.concatMapStringsSep " " (a: lib.escapeShellArg a) rendered}"
                else
                  "spawn-sh ${lib.escapeShellArg (builtins.head rendered)}";
              renderBind =
                name: value:
                let
                  actionStr = renderAction value.action;
                  allowLocked =
                    if value.allowLocked == null then
                      ""
                    else if value.allowLocked then
                      " allow-when-locked=true"
                    else
                      " allow-when-locked=false";
                in
                "${name}${allowLocked} { ${actionStr} }";
            in
            ''
              binds {
                ${lib.concatStringsSep "\n\t" (lib.mapAttrsToList renderBind cfg.binds)}
              }
            '';

        in
        ''
          ${blur}
          ${mouse}
          ${binds}
        '';
    };
}
