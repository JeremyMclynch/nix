if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Direnv + Zoxide
    command -v direnv &>/dev/null && direnv hook fish | source
    command -v zoxide &>/dev/null && zoxide init fish --cmd cd | source

    set dotpath /home/jeremy/nix/dots

    set sshpath (which ssh)
    set system (hostname)

    # Better ls
    alias ls='eza --icons --group-directories-first -1'
    alias ssh='TERM=xterm-256color $sshpath'
    alias clip='wl-copy'
    alias softboot='systemctl soft-reboot'

    if [ "$system" = nixos-desktop ]
        set systemname desktop
    else
        set systemname laptop
    end

    # Abbrs
    abbr rebuild '$dotpath/../scripts/rebuild.sh $systemname'
    abbr rebuild-clean 'sudo nixos-rebuild switch --flake ~/nix/#$systemname'
    abbr cdhome 'cd ~/nix/home/jeremy/'
    abbr vipkg 'nvim ~/nix/home/jeremy/packages.nix'
    abbr vihost 'nvim ~/nix/hosts/$systemname/default.nix'
    abbr vihome 'nvim ~/nix/home/jeremy/common.nix'
    abbr vpn 'openconnect-sso --server vpn.njit.edu -- --backgrouind'
    abbr sshwulver 'ssh jmm277@wulver.njit.edu'
    abbr sshwspr1 'ssh wsprdaemon@njit-bl-1'
    abbr sshwspr2 'ssh wsprdaemon@njit-bl-2'
    abbr sshd 'ssh jeremy@archdesktop'
    abbr viconf 'nvim $dotpath/hypr/hyprland.conf'
    abbr vivar 'nvim $dotpath/hypr/variables.conf'
    abbr vibind 'nvim $dotpath/hypr/hyprland/keybinds.conf'
    abbr vivar 'nvim $dotpath/hypr/variables.conf'
    abbr cdh 'cd $dotpath/hypr/hyprland/'
    abbr vifish 'nvim $dotpath/fish/config.fish'
    abbr vi nvim
    abbr vim nvim
    abbr lg lazygit
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr rsyncd 'rsync -avzP'
    abbr l ls
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end

    functions -c cd orig_cd

    function cd
        if [ -z "$argv" ]
            orig_cd ~ && ls
        else
            orig_cd "$argv" && ls
        end
    end

end
