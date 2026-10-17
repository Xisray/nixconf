{self, ...}: {
  flake.modules.generic.voxtype = {
    wlib,
    lib,
    config,
    pkgs,
    ...
  }: let
    modelHashes = {
      "tiny" = "sha256-vgfgSOHlma1GNByNKhNWRQl6U4IhZ4t6zdGxkZxuGyE=";
      "tiny.en" = "sha256-kh5M+Ghv3Zk9zQgaXaW2w2W/3hFi5ysI11rHUomSCx8=";
      "base" = "sha256-YO1bw90U7qhWST0zQ0m0BXgt3K8AKNS130CINF+6Lv4=";
      "base.en" = "sha256-oDd5yG3zMjB19eeWyyzlAp8A7Ihp7uP9+4l6/jbG0AI=";
      "small" = "sha256-G+OpsgY4Z7k35k4ux0gzZKeZF+FX+pjF2UtcH//qmHs=";
      "small.en" = "sha256-xhONbVjsyDIgl+D5h8MvG+i7ChhTKj+I9zTRu/nEHl0=";
      "medium" = "sha256-bBTVre5fhjlAN7Tk6LWfFnO2zuEOPPCxG72+55wVYgg=";
      "medium.en" = "sha256-zDfpNHgzjsdwAoGnrDChASiSnrj0J92i6GX6qPbaQ1Y=";
      "large-v3" = "sha256-ZNGCtEC5jVIDxPm9VBVE2ExgUZbE97hF36EfsjWU0eI=";
      "large-v3-turbo" = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
    };
  in {
    imports = [wlib.modules.default wlib.modules.systemd];
    options = {
      settings = lib.mkOption {
        type = lib.types.attrsOf (wlib.types.structuredValueWith {
          nullable = false;
          typeName = "TOML";
        });
        default = {};
      };
    };
    config = let
      modelFile = name:
        pkgs.fetchurl {
          url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-${name}.bin";
          hash = modelHashes.${name};
        };
      resolveModel = model:
        if lib.hasPrefix "/" model
        then model
        else if modelHashes ? ${model}
        then toString (modelFile model)
        else
          throw ''
            voxtype: unknown settings.whisper.model = "${model}".
            Use an absolute path or one of: ${lib.concatStringsSep ", " (lib.attrNames modelHashes)}
          '';
      model = config.settings.whisper.model or null;
      finalSettings =
        if model == null
        then config.settings
        else lib.recursiveUpdate config.settings {whisper.model = resolveModel model;};
    in {
      package = lib.mkDefault pkgs.voxtype;
      runtimePkgs = [pkgs.coreutils pkgs.which pkgs.wl-clipboard pkgs.wtype];
      settings = {
        state_file = lib.mkDefault "auto";
        hotkey.enabled = lib.mkDefault false;
      };
      flags."--config" = (pkgs.formats.toml {}).generate "voxtype-config.toml" finalSettings;
      systemd.user.service.voxtype = {
        enable = true;
        Unit = {
          Description = "Voxtype speech-to-text daemon";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          Type = "exec";
          ExecStart = "${placeholder "out"}/bin/voxtype daemon";
          Restart = "on-failure";
          RestartSec = "5s";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    };
  };

  flake.wrappers.voxtype = {pkgs, ...}: let
  in {
    imports = [self.modules.generic.voxtype];
    package = pkgs.voxtype-vulkan;
    settings = {
      whisper = {
        model = "large-v3-turbo";
        language = [
          "en"
          "ru"
        ];
        translate = false;
      };
      output = {
        mode = "type";
        fallback_to_clipboard = true;
      };
    };
  };
}
