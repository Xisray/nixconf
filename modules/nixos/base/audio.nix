{ ... }: {
  flake.nixosModules.audio = {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      wireplumber.extraConfig."51-hide-hdmi-audio" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "node.name" = "~alsa_output\\..*HDMI.*"; } ];
            actions.update-props."node.disabled" = true;
          }
        ];
      };
    };
  };
}
