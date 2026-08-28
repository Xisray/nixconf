{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.fish = inputs.wrapper-modules.wrappers.fish.wrap {
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
                
                # Функции
        				function nswitch
                    if set -q argv[1]
                        sudo nixos-rebuild switch --flake $HOME/nixconf\#$argv[1]
                    else
                        sudo nixos-rebuild switch --flake "$HOME/nixconf"
                    end
        				end

                function findf
                    fd "$argv" | fzf
                end

                function cd
                    z "$argv"
                end

                function nvim
                    set -l file (fzf --preview 'bat --style=numbers --color=always {}')
                    if test -n "$file"
                        command nvim "$file"
                    end
                end

                # Инициализация zoxide
                ${lib.getExe pkgs.zoxide} init fish | source

                # Дополнительные настройки
                set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
                set -gx FZF_PREVIEW_COMMAND 'bat --style=numbers,changes --color=always {}'
      '';
    };
  };
}
