{
  flake.wrappers.fastfetch = {
    wlib,
    lib,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.fastfetch];
    options = {
      border = lib.mkOption {
        type = lib.types.enum ["square" "rounded"];
        default = "square";
      };
    };
    config.settings = let
      square = config.border == "square";
    in {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      display = {
        color = {
          keys = "blue";
        };
        separator = "";
        constants = [
          "───────────────"
          "──────────────────────────────────────────────────────"
          (
            if square
            then "┌"
            else "╭"
          )
          (
            if square
            then "┐"
            else "╮"
          )
          (
            if square
            then "└"
            else "╰"
          )
          (
            if square
            then "┘"
            else "╯"
          )
          "┬"
          "┴"
          "│"
          "\\u001b[1m"
          "\\u001b[54D"
          "\\u001b[54C"
          "\\u001b[11C"
          "\\u001b[s"
          "\\u001b[u"
          "\\u001b[44D"
        ];
        brightColor = false;
      };
      modules = [
        {
          type = "custom";
          key = "{$3}{$1}{$7}{$2}{$4}{$16}";
          format = " {#blue}System ";
        }
        {
          type = "os";
          key = "{$9} {icon}  {$14}{sysname}{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "datetime";
          key = "{$9} {icon}  {$14}Fetched{$15}{$13}{$9}{$12}{$9}{$11}";
          format = "{year}-{month-pretty}-{day-pretty} {hour-pretty}:{minute-pretty}:{second-pretty} {timezone-name}";
        }
        {
          type = "locale";
          key = "{$9} {icon}  {$14}Locale{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "uptime";
          key = "{$9} {icon}  {$14}Uptime{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "users";
          myselfOnly = true; # Only show current user
          keyIcon = "";
          key = "{$9} {icon}  {$14}Login{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          condition = {
            # Conditional module: only show on non-macOS
            "!system" = "macOS";
          };
          type = "disk";
          keyIcon = "";
          key = "{$9} {icon}  {$14}OS Age{$15}{$13}{$9}{$12}{$9}{$11}";
          folders = "/"; # Check root filesystem
          format = "{create-time:10} [{days} days]"; # Show creation time and age in days
        }
        {
          condition = {
            # Conditional module: only show on macOS
            system = "macOS";
          };
          type = "disk";
          keyIcon = "";
          key = "{$9} {icon}  {$14}OS Age{$15}{$13}{$9}{$12}{$9}{$11}";
          folders = "/System/Volumes/VM"; # Work around for APFS on macOS
          format = "{create-time:10} [{days} days]";
        }
        {
          type = "custom";
          key = "{$5}{$1}{$8}{$2}{$6}";
        }
        # Hardware Section
        {
          type = "custom";
          key = "{#cyan}{$3}{$1}{$7}{$2}{$4}{$16}";
          format = " {#bright_cyan}Hardware ";
        }
        {
          type = "chassis";
          key = "{#cyan}{$9} {icon}  {$14}Chassis{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "memory";
          key = "{#cyan}{$9} {icon}  {$14}RAM{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "swap";
          key = "{#cyan}{$9} {icon}  {$14}SWAP{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "cpu";
          key = "{#cyan}{$9} {icon}  {$14}CPU{$15}{$13}{$9}{$12}{$9}{$11}";
          showPeCoreCount = true;
        }
        {
          type = "gpu";
          key = "{#cyan}{$9} {icon}  {$14}GPU{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "disk";
          key = "{#cyan}{$9} {icon}  {$14}Disk{$15}{$13}{$9}{$12}{$9}{$11}";
          format = "{mountpoint} {size-used} \/ {size-total} ({size-percentage}) - {filesystem}";
        }
        {
          type = "battery";
          key = "{#cyan}{$9} {icon}  {$14}Battery{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "custom";
          key = "{#cyan}{$5}{$1}{$8}{$2}{$6}";
        }
        # Desktop Section
        {
          type = "custom";
          key = "{#green}{$3}{$1}{$7}{$2}{$4}{$16}";
          format = " {#bright_green}Desktop ";
        }
        {
          type = "de";
          key = "{#green}{$9} {icon}  {$14}Desktop{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "wm";
          key = "{#green}{$9} {icon}  {$14}Session{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "display";
          key = "{#green}{$9} {icon}  {$14}Display{$15}{$13}{$9}{$12}{$9}{$11}";
          "compactType" = "original-with-refresh-rate";
        }
        {
          type = "gpu";
          key = "{#green}{$9} {icon}  {$14}G-Driver{$15}{$13}{$9}{$12}{$9}{$11}";
          format = "{driver}";
        }
        {
          type = "custom";
          key = "{#green}{$5}{$1}{$8}{$2}{$6}";
        }
        # Terminal Section
        {
          type = "custom";
          key = "{#yellow}{$3}{$1}{$7}{$2}{$4}{$16}";
          format = " {#bright_yellow}Terminal ";
        }
        {
          type = "shell";
          key = "{#yellow}{$9} {icon}  {$14}Shell{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "terminal";
          key = "{#yellow}{$9} {icon}  {$14}Terminal{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "terminalfont";
          key = "{#yellow}{$9} {icon}  {$14}Term Font{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "colors";
          key = "{#yellow}{$9} {icon}  {$14}Colors{$15}{$13}{$9}{$12}{$9}{$11}";
          symbol =
            if square
            then "square"
            else "circle";
        }
        {
          type = "packages";
          key = "{#yellow}{$9} {icon}  {$14}Packages{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "custom";
          key = "{#yellow}{$5}{$1}{$8}{$2}{$6}";
        }
        # Development Section
        {
          type = "custom";
          key = "{#red}{$3}{$1}{$7}{$2}{$4}{$16}";
          format = " {#bright_red}Development ";
        }
        {
          type = "command";
          keyIcon = "";
          key = "{#red}{$9} {icon}  {$14}Rust{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "rustc --version";
          format = "rustc {~6;13}";
        }
        {
          type = "command";
          condition = {
            "!system" = "Windows"; # Posix version
          };
          keyIcon = "";
          key = "{#red}{$9} {icon}  {$14}Clang{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "clang --version | sed -n 's/.*version \\([0-9][0-9.]*\\).*/\\1/p'";
          format = "clang {}";
        }
        {
          type = "command";
          condition = {
            system = "Windows"; # Windows version
          };
          keyIcon = "";
          key = "{#red}{$9} {icon}  {$14}Clang{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "clang --version | findstr version";
          format = "clang {~14;20}";
        }
        {
          type = "command";
          keyIcon = "";
          key = "{#red}{$9} {icon}  {$14}NodeJS{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "node --version";
          format = "node {~1}";
        }
        {
          type = "command";
          keyIcon = "";
          key = "{#red}{$9} {icon}  {$14}Python{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "python --version";
          format = "python {~7}"; # {~7} removes first 7 characters ("Python" with extra space)
        }
        {
          type = "command";
          keyIcon = "";
          key = "{#red}{$9} {icon}  {$14}Go{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "go version | cut -d' ' -f3";
          format = "go {~2}"; # {~2} removes first 2 characters (go)
        }
        {
          type = "command";
          keyIcon = "";
          key = "{#red}{$9} {icon}  {$14}Zig{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "zig version";
          format = "zig {}";
        }
        {
          type = "editor";
          key = "{#red}{$9} {icon}  {$14}Editor{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "command";
          keyIcon = "󰊢";
          key = "{#red}{$9} {icon}  {$14}Git{$15}{$13}{$9}{$12}{$9}{$11}";
          text = "git version";
          format = "git {~12}";
        }
        {
          type = "font";
          key = "{#red}{$9} {icon}  {$14}Interface{$15}{$13}{$9}{$12}{$9}{$11}";
        }
        {
          type = "custom";
          key = "{#red}{$5}{$1}{$8}{$2}{$6}";
        }
      ];
    };
  };
}
