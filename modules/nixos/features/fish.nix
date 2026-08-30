{ inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.shell = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      package = pkgs.fish;
      runtimePkgs = with pkgs; [
        fzf
        ripgrep
        lsd
        bat
        zoxide
        fd
        btop
        yazi
      ];
      env = {
        EDITOR = "nvim";
      };
      configFile.content = ''
        set -g fish_greeting ""
        # Алиасы
        alias ls='lsd'
        alias ll='ls -l'
        alias la='ls -a'
        alias lla='ls -la'
        alias lt='ls --tree'
        alias grep='rg'
        alias cat='bat --paging=never'
        alias top='btop'
        alias y='yazi'
        alias ..='cd ..'
        alias v='nvim'
        alias g='git'
        alias gst='git status'
        alias gl='git pull'
        alias gp='git push'
        alias gc='git commit -v'
        alias gc!='git commit -v --ammend'
        alias gca='git commit -v -a'
        alias gca!='git commit -v -a --ammend'
        alias gcmsg='git commit -m'

        # Функции
        function nswitch
            if set -q argv[1]
                sudo nixos-rebuild switch --flake $HOME/nixconf\#$argv[1]
            else
                sudo nixos-rebuild switch --flake "$HOME/nixconf"
            end
        end

        function cd
            z "$argv"
        end

        # Инициализация zoxide
        # ${lib.getExe pkgs.zoxide} init fish | source

        # Дополнительные настройки
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -gx FZF_PREVIEW_COMMAND 'bat --style=numbers,changes --color=always {}'
      '';
    };
  };
}
