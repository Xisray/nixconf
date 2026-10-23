{
  flake.wrappers.starship = {
    wlib,
    lib,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.starship];
    options = {
      colors = {
        primary = lib.mkOption {
          type = lib.types.str;
          default = "blue";
        };
        base = lib.mkOption {
          type = lib.types.str;
          default = "black";
        };
        peach = lib.mkOption {
          type = lib.types.str;
          default = "yellow";
        };
        lavender = lib.mkOption {
          type = lib.types.str;
          default = "bright-white";
        };
        flamingo = lib.mkOption {
          type = lib.types.str;
          default = "bright-yellow";
        };
      };
      rounded = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      type = lib.mkOption {
        type = lib.types.enum ["simple" "modern"];
        default = "simple";
      };
      frame = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
    config.settings = let
      open =
        if config.rounded
        then ""
        else "█";
      close =
        if config.rounded
        then ""
        else "█";
      bot =
        if config.rounded
        then "╰"
        else "└";
      top =
        if config.rounded
        then "╭"
        else "┌";
      modern = config.type == "modern";
      mkFormat = s:
        if modern
        then "([${close} ](fg:prev_bg bg:$style)[${s}](bg:$style fg:base))"
        else "([${s}]($style) )";
      format = mkFormat "$symbol$version";
    in {
      palette = "nix";
      add_newline = true;
      continuation_prompt = "[▸▹ ](primary)";
      format = lib.concatStrings [
        (lib.optionalString config.frame "[${top}](fg:primary)")
        "$username"
        "$directory"
        "$git_branch"
        "$git_status"
        "$git_metrics"
        "$package"
        "$nodejs"
        "$bun"
        "$python"
        "$rust"
        "$golang"
        "$java"
        "$c"
        "$cpp"
        "$lua"
        "$ruby"
        "$php"
        "$docker_context"
        "$cmd_duration"
        (lib.optionalString modern "[${close}](fg:prev_bg)")
        "\n"
        (lib.optionalString config.frame "[${bot}─](fg:primary)")
        "$character"
      ];
      character = {
        format = "$symbol ";
        success_symbol = "[${if config.frame then "❯" else "➜"}](bold primary)";
        error_symbol = "[${if config.frame then "❯" else "✗"}](bold red)";
        vimcmd_symbol = "[${if config.frame then "❮" else "■"}](primary)";
      };
      username = {
        format =
          if modern
          then "([${open}]($style)[ $user](bg:$style fg:base))"
          else "([ $user]($style) )";
        style_user = "primary";
        style_root = "red";
        show_always = true;
      };
      directory = {
        format =
          if modern
          then "([${close} ](fg:prev_bg bg:$style)[󰉋 $path](bg:$style fg:base)[$read_only](bg:$style fg:$read_only_style))"
          else "([󰉋 $path]($style)[$read_only]($read_only_style) )";
        read_only = " ◈";
        style = "peach";
      };
      git_branch = {
        format = mkFormat "$symbol$branch";
        symbol = " ";
        style =
          if modern
          then "green"
          else "bold green";
        only_attached = true;
      };
      git_status = lib.mkIf modern {
        format = "([ $all_status$ahead_behind](bg:$style fg:base))";
        style = "green";
      };
      git_metrics = {
        disabled = modern;
      };
      package = {
        inherit format;
        symbol = " ";
        style = "bright-purple";
      };
      nodejs = {
        inherit format;
        style = "cyan";
      };
      bun = {
        inherit format;
        symbol = " ";
        style = "flamingo";
      };
      python = {
        format = mkFormat "\${symbol}\${pyenv_prefix}(\${version})( \\($virtualenv\\))";
        style = "blue";
        symbol = " ";
      };
      rust = {
        inherit format;
        symbol = " ";
        style = "bright-red";
      };
      golang = {
        inherit format;
        symbol = " ";
        style = "bright-cyan";
      };
      java = {
        inherit format;
        symbol = " ";
        style = "red";
      };
      c = {
        inherit format;
        symbol = " ";
        style = "lavender";
      };
      cpp = {
        disabled = false;
        inherit format;
        symbol = " ";
        style = "lavender";
      };
      lua = {
        inherit format;
        symbol = " ";
        style = "blue";
      };
      ruby = {
        inherit format;
        symbol = " ";
        style = "red";
      };
      php = {
        inherit format;
        symbol = " ";
        style = "lavender";
      };
      docker_context = {
        format = mkFormat "$symbol$context";
        symbol = " ";
        style = "bright-blue";
        only_with_files = true;
      };
      cmd_duration = {
        format = mkFormat "󰔛 $duration";
        style = "yellow";
      };
      palettes.nix = config.colors;
    };
  };
}
