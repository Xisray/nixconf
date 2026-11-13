{
  flake.wrappers.mpv = {
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.mpv];
    script = {
      modernz = {
        path = pkgs.mpvScripts.modernz;
        opts = {
          layout = "compact"; # default | compact | mini | seekbar
          icon_theme = "fluent"; # fluent | material
          icon_style = "mixed"; # mixed | filled | outline
          keeponpause = "bottombar";
          hidetimeout = 1500;
        };
      };
      thumbfast.path = pkgs.mpvScripts.thumbfast;
      mpris.path = pkgs.mpvScripts.mpris;
      sponsorblock.path = pkgs.mpvScripts.sponsorblock;
      autoload.path = pkgs.mpvScripts.autoload;
    };
    "mpv.conf".content = ''
      osc=no
      title-bar=no
      border=no

      vo=gpu-next
      hwdec=auto-safe
      gpu-api=vulkan
      video-sync=display-resample
      interpolation=yes
      tscale=oversample

      volume=70
      volume-max=150

      sub-auto=fuzzy
      sub-font-size=42
      sub-border-size=2

      cache=yes
      demuxer-max-bytes=512MiB
      demuxer-max-back-bytes=128MiB
      ytdl-format=bestvideo+bestaudio/best

      keep-open=yes
      save-position-on-quit=yes
      watch-later-options-clr=yes
      screenshot-directory=~/Pictures/mpv
      screenshot-template=%F-%P
      screenshot-format=png

      osd-font-size=28
      osd-duration=1500
    '';

    "mpv.input".content = ''
      v   script-binding modernz/visibility
      V   script-message-to modernz osc-visibility cycle
      w   script-binding modernz/progress-toggle

      WHEEL_UP      add volume 2
      WHEEL_DOWN    add volume -2
      Ctrl+WHEEL_UP   add speed 0.1
      Ctrl+WHEEL_DOWN add speed -0.1
      MBTN_MID      cycle pause
      Ctrl+s        screenshot
      Alt+s         screenshot video
    '';
  };
}
