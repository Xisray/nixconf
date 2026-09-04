{
  flake.homeModules.starship = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        continuation_prompt = "[▸▹ ](dimmed white)";

        format = ''
          $username\
          $directory\
          $git_branch\
          $git_status\
          $git_metrics\
          $package\
          $nodejs\
          $bun\
          $python\
          $rust\
          $golang\
          $java\
          $c\
          $cpp\
          $lua\
          $ruby\
          $php\
          $docker_context\
          $cmd_duration\
          \n$character'';

        character = {
          format = "$symbol ";
          success_symbol = "[➜](bold bright-green)";
          error_symbol = "[✗](bold red)";
          vimcmd_symbol = "[■](dimmed green)";
        };

        username = {
          style_user = "bright-blue bold";
          style_root = "bold red";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
          aliases = {
            "Administrator" = "Xisray";
          };
        };

        directory = {
          read_only = " ◈";
          style = "bright-blue";
          format = "[󰉋](yellow) [$path]($style)[$read_only]($read_only_style) ";
        };

        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style)";
          symbol = " ";
          style = "bold green";
          only_attached = true;
        };

        git_status.style = "bold purple";

        package.format = "[$symbol$version]($style) ";

        nodejs.format = "[$symbol$version]($style) ";

        python.format = "[\${symbol}\${pyenv_prefix}(\${version} )(\($virtualenv\) )]($style)";

        rust.format = "[$symbol($version )]($style)";

        golang.format = "[$symbol$version]($style) ";
      };
    };
  };
}
