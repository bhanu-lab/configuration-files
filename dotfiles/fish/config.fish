# Init
set fish_greetings

# Paths
set PATH /home/user/.cargo/bin $PATH
set PATH /home/user/.local/bin $PATH
set PATH /home/user/go/bin $PATH
set PATH /home/user/.npm-global/bin $PATH
#set PATH /home/user/.nimble/bin $PATH
set PATH /home/user/.nix-profile/bin $PATH
#set PATH /home/user/.guix-profile/bin $PATH
#set PATH /home/user/.deno/bin $PATH
#set PATH /var/lib/snapd/snap/bin $PATH
#set PATH /home/linuxbrew/.linuxbrew/bin $PATH
#set PATH /home/user/.emacs.d/bin $PATH
#set PATH /usr/lib/ccache/bin/ $PATH

# Starship - prompt
starship init fish | source

# Notification
set -U __done_min_cmd_duration 10000

# Plugin
#- ctrl+f -> file search
#- ctrl+r -> fly through history
set YSU_MESSAGE_POSITION "before"
#mcfly init fish | source # ctrl+r

#sh -C /home/user/.config/fish/startup &>/dev/null

# Output Colorizer
source /usr/share/grc/grc.fish

# Zoxide - cd alter
zoxide init fish | source

# TheFuck
thefuck --alias | source

## -- Overwrites -- ##

# Overwrites - Functions
function d; z "$argv" ; l; end
function di; zi "$argv" ; l; end
function search; fd "$argv"; end
function qrcode; curl qrenco.de/"$argv[1]"; end
function imagec; imager -i "$argv[1]" -o "$argv[1]"; end

# System
alias dmesg="dmesg --color=always"
alias uefi-utility-setup="systemctl reboot --firmware-setup"

# Overwrites - Aliases
alias ls="exa -la --header --group --inode --blocks --git --icons"
alias l="exa -ll --header --group --inode --blocks --git --icons"
alias lt="exa -T --icons"
alias mkdir="mkdir -vp"
alias mkfile="touch"
alias dog="dog -n"
alias rm="rm -rfiv"
alias mv="mv -v"
alias rename="mv -v"
alias cp="cp -rv"
alias ..="cd .. ; l"
alias mpv="mpv --hwdec=vaapi"

# Misc
alias rip="rip -i"
alias btop="btm"
alias lc="tokei"
alias fview="bat"
alias readme="glow"
alias dup="runiq"
alias untar="tar -xvf"
alias copy="xclip -sel clip"
alias ports="netstat -tulpen"
alias regex="grex"

# Fun
alias cheatsheet="cheat.sh"
alias joke="curl https://icanhazdadjoke.com"
alias cmatrix="cmatrix -r -u 1"

# Git
function gc; git add . ; git commit -m "$argv[1]" -m "Signed-off-by: molese <molese@protonmail.com>" ; end
alias git-pull-all="/bin/ls | xargs -I{} git -C {} pull"

# PORTAGE #
#alias overlays="portageq repos_config / | sed -nE 's/^[[:space:]]*\[(.+)\]/\1/p' | grep -vxF DEFAULT"

# Nix
function nix-install; nix-env -iA nixpkgs."$argv"; end
alias nix-update="nix-channel --update"
alias nix-upgrade="nix-env -u"
alias nix-search="nix search"
alias nix-uninstall="nix-env --uninstall"

# Guix
#alias guix-update="guix pull ; guix package -u"
#alias guix-upgrade="guix upgrade"
#alias guix-install="guix install"
#alias guix-uninstall="guix uninstall"
#alias guix-list="guix package --list-installed"

# Compiler Flags
export COMMON_FLAGS="-march=native -O3 -pipe"
export FCFLAGS="-march=native -O3 -pipe"
export FFLAGS="-march=native -O3 -pipe"
export CFLAGS="-march=native -O3 -pipe"
export CXXFLAGS="-march=native -O3 -pipe"
export CPPFLAGS="-march=native -O3 -pipe"
export LDFLAGS="-Wl,-O3 -Wl,--as-needed -s -march=native -O3 -pipe"
#export RUSTFLAGS="-C target-cpu=native -C opt-level=3 -C debuginfo=0 -C link-dead-code=no"

# JOBS
export \
    MAKEFLAGS="-j4 --no-print-directory" \
    CARGO_BUILD_JOBS="4"

# SCCACHE
#export RUSTC_WRAPPER="/usr/bin/sccache"
#export SCCACHE_DIR="/home/user/.cache/sccache"
#export SCCACHE_CACHE_SIZE="100G"

# CCACHE
#export CCACHE_DIR="/home/user/.cache/ccache"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /home/user/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# Dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT="true"

# Bedrock Linux
#alias wine="strat -r arch wine"
# alias proton="STEAM_COMPAT_DATA_PATH='/home/user/.proton' PROTON_NO_ESYNC=1 PROTON_DUMP_DEBUG_COMMANDS='1' strat -r arch /home/user/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Proton\ 5.13/proton run"

# SSH
alias git-ssh-verify="eval (keychain --eval --agents ssh -Q --quiet ~/.ssh/id_ed25519 --nogui)"
