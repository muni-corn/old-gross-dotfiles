if status is-interactive
   cat ~/.config/wpg/sequences
end

bash /etc/profile
bash ~/.bashrc

alias btrfs-csum-errors="sudo dmesg | grep 'checksum error at' | cut -d\  -f27- | sed 's/.\$//' | sort | uniq"
alias config='/usr/bin/git --git-dir=$HOME/.dots.git/ --work-tree=$HOME'
alias gentoo-system-upgrade="sudo emerge -vuUND --autounmask-write --keep-going --with-bdeps=y --backtrack=1000 @world"
alias imv="imv -e Monospace:13"
alias pandoc-preview="~/.config/nvim/pandocPreview.sh"

alias g="git"
alias n="nvim"
alias r="ranger"
alias s="dbus-run-session sway"

set fish_greeting ""
set -gx ANDROID_EMULATOR_USE_SYSTEM_LIBS 1
set -gx BAT_THEME base16
set -gx BROWSER /bin/firefox
set -gx EDITOR /bin/nvim
set -gx EIX_LIMIT 0
set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git --ignore node_modules -g ""'
set -gx GOPATH $HOME/go
set -gx GPG_TTY (tty)
set -gx LEDGER_FILE $HOME/Notebook/ledger/main.sfox
set -gx NODE_BIN $HOME/.npm-global/bin
set -gx QT_QPA_PLATFORMTHEME qt5ct
set -gx RUSTBIN $HOME/.cargo/bin
set -gx SUDO_ASKPASS /usr/bin/ksshaskpass
set -gx SXHKD_SHELL '/bin/sh'
set -gx TZ America/Boise
set -gx WINEPREFIX $HOME/.wine/
set -gx XBPS_DISTDIR $HOME/code/void/packages

# sway recommended settings
set -gx CLUTTER_BACKEND wayland
set -gx ECORE_EVAS_ENGINE wayland-egl
set -gx ELM_ENGINE wayland_egl
set -gx MOZ_ENABLE_WAYLAND 1
set -gx NO_AT_BRIDGE 1
set -gx QT_QPA_PLATFORM wayland-egl
set -gx SDL_VIDEODRIVER wayland
set -gx _JAVA_AWT_WM_NONREPARENTING 1

set -gx PATH $GOPATH/bin $RUSTBIN $PATH $HOME/.local/bin $NODE_BIN /usr/lib $HOME/bin

function fish_prompt --description 'Write out the prompt'
    set -l color_cwd
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end

    echo -n -s (set_color $color_cwd) (prompt_pwd) (set_color normal) ' ' "$suffix "
end

function nohup
    command nohup $argv </dev/null >/dev/null 2>&1 & disown
end

function encrypt
    gpg -c $argv[1] && rm $argv[1]
end

# ??? TODO
# function decrypt
#     gpg -d $argv[1] && rm $argv[1]
# end

function crypt-edit
    if count $argv > /dev/null
        # set temp file
        set temp (mktemp)

        if test -e $argv[1]
            # decrypt the file
            echo "decrypting file..."
            gpg --yes -o $temp -d $argv[1]
        else
            echo "$argv[1] doesn't exist, but we'll create it"
        end

        # edit it, if successful
        and begin
            $EDITOR $temp

            # re-encrypt the file
            echo "encrypting file..."
            gpg --yes -o $argv[1] -c $temp
        end

        # or, don't
        or begin
            echo "file wasn't decrypted successfully, quitting"
            return 1
        end

        # remove decrypted file
        rm -f $temp

        echo "all done!"
    else
        echo "no file given."
    end
end

if ! status is-login
    eval (keychain -q --gpg2 --agents "gpg,ssh" --eval id_rsa_github id_rsa_bitbucket id_ed25519 4B21310A52B15162) 2> /dev/null
end

alias enable-conda="eval /home/muni/.anaconda3/bin/conda "shell.fish" "hook" $argv | source"