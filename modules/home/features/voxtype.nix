{
  flake.homeModules.voxtype = { pkgs, ... }: {
    services.voxtype = {
      enable = true;
      package = pkgs.voxtype-vulkan;
      loadModels = [ "large-v3-turbo" ];
      settings = {
        hotkey = {
          enabled = true;
          key = "SCROLLLOCK";
          mode = "push_to_talk";
        };

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
    preferences.binds."Pause".action = [
      "voxtype"
      "record"
      "toggle"
    ];

    preferences.persistance.cache.directories = [
      ".local/share/voxtype"
    ];
  };
}
