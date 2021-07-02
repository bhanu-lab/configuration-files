# Init
set fish_greetings

# Paths
set PATH /home/user/.cargo/bin $PATH
set PATH /home/user/.local/bin $PATH
set PATH /home/user/go/bin $PATH
set PATH /home/user/.npm-global/bin $PATH
set PATH /var/lib/snapd/snap/bin $PATH
#set PATH /home/linuxbrew/.linuxbrew/bin $PATH
#set PATH /home/user/.emacs.d/bin $PATH
#set PATH /usr/lib/ccache/bin/ $PATH
set PATH /home/user/.guix-profile/bin $PATH
set PATH /home/user/.deno/bin $PATH

# Starship - prompt
starship init fish | source

# Notification
set -U __done_min_cmd_duration 10000

# Plugin
#- ctrl+f -> file search
set YSU_MESSAGE_POSITION "before"
mcfly init fish | source # ctrl+r

#sh -C /home/user/.config/fish/startup &>/dev/null

# Output Colorizer
source /usr/share/grc/grc.fish

# Zoxide - cd alter
zoxide init fish | source

# TheFuck
thefuck --alias | source

# Navi
#navi widget fish | source
function __call_navi
    navi --print
end

function navi-widget -d "Show cheat sheets"
  begin
    set ttysettings (stty -g)
    stty sane
    __call_navi | perl -pe 'chomp if eof' | read -lz result
    and commandline -- $result

    stty $ttysettings
  end
  commandline -f repaint
end

bind \cg navi-widget
if bind -M insert > /dev/null 2>&1
  bind -M insert \cn navi-widget
end

## -- Overwrites -- ##

# Overwrites - Functions
function d; z "$argv" ; l; end
function di; zi "$argv" ; l; end
function search; fd "$argv" | as-tree; end
function replace; ruplacer "$argv[1]" "$argv[2]" "$argv[3]" --go; end
function qtcode; curl qrenco.de/"$argv[1]"; end

# System
alias dmesg="dmesg --color=always"
alias uefi-utility-setup="systemctl reboot --firmware-setup"

# Overwrites - Aliases
alias ls="exa -la --header --group --inode --blocks --git --icons"
alias l="exa -ll --header --group --inode --blocks --git --icons"
alias lt="exa -T --icons"
alias mkdir="mkdir -vp"
alias mkfile="touch"
alias grep="rg"
alias dog="dog -n"
alias rm="rm -v"
alias mv="mv -v"
alias cp="cp -v"
alias ..="cd .. ; l"

# Misc
alias t="br -s"
alias dl="axel"
alias rip="rip -i"
alias btop="btm"
alias gstats="onefetch"
alias bandwhich="doas bandwhich"
alias lc="tokei"
alias fview="bat"
alias readme="glow"
alias dup="runiq"
alias sysres="htop"
alias resgraph="s-tui"
alias isearch="sk"
alias risearch="sk --ansi -i -c 'rg --color=always --line-number '{}''"
alias organize="organize-rt -s . -o organized -rH --dry-run"
alias procst="procs --tree"
alias procsc="procs --sortd cpu"
alias procsm="procs --sortd mem"
alias untar="tar -xvf"
alias copy="xclip -sel clip"
alias ports="netstat -tulpen"
alias disk="df -Th"
alias disks="lsblk"
alias regex="grex"

# Bedrock Linux #
alias bfetch="doas brl fetch"
alias slist="brl fetch --list --experimental"

# Rust
#- cargo
alias cinstall="cargo install"
alias cuninstall="cargo uninstall"
#- misc
alias rrepl="evcxr"
alias rustlab="/home/user/rustlab.sh"

# Fun
alias cheatsheet="cheat.sh"
alias joke="curl https://icanhazdadjoke.com"
alias cmatrix="cmatrix -r -u 1"
alias encrypt="nms"
alias map="telnet mapscii.me"
alias c19stats="curl snf-878293.vm.okeanos.grnet.gr"
alias howto="HOWDOI_COLORIZE=1 howdoi"
alias animate="chalk-animation"

# Git
alias git-pull-all="/bin/ls | xargs -I{} git -C {} pull"
alias GG="git add . ; git commit -m"
alias GGG="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} pull"
alias gsignall="git rebase -i --root --exec 'git commit --amend --no-edit --no-verify -S'"

# PORTAGE #
# Emerge
alias pupgrade="doas emerge -uDN @world"
alias premergeall="doas emerge -e --keep-going=y @world"
alias pinstall="doas emerge"
alias puninstall="doas emerge -C"
alias psearch="doas emerge --search"
alias psync="doas emerge --sync"
alias pclean="doas emerge --depclean"
# Tools
alias pupdate="doas etc-update"
alias mrgtime="doas genlop -t"
alias plist="qlist -IRSv"
alias puse="equery uses"
alias pdep="equery depends"
alias radd="doas layman -a"
alias rdel="doas layman -d"
alias rdev="doas emerge revdep-rebuild -v"
alias pprebuild="doas emerge @preserved-rebuild"
alias whichcmd="e-file"
alias reperl="perl-cleaner --all"
alias rehaskell="haskell-updater"
alias uses="euse -i"
alias hasuse="equery hasuse"
alias usedes="equery uses"
alias overlays="portageq repos_config / | sed -nE 's/^[[:space:]]*\[(.+)\]/\1/p' | grep -vxF DEFAULT"
alias erepo="doas eselect repository enable"
alias elist="eselect repository list"
# Misc
alias pworld="dog /var/lib/portage/world"

# Nix
alias nix-update="nix-channel --update"
alias nix-upgrade="nix-env -u"
alias nix-search="nix search"
function nix-install; nix-env -iA nixpkgs."$argv"; end
alias nix-uninstall="nix-env --uninstall"

# Guix
alias guix-update="guix pull ; guix package -u"
alias guix-upgrade="guix upgrade"
alias guix-install="guix install"
alias guix-uninstall="guix uninstall"
alias guix-list="guix package --list-installed"

# Extras
alias picom-gaming="pkill picom ; picom --config /home/user/.config/picom/picom-gaming.conf"

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
#export \
#    MAKEFLAGS="-j4 --no-print-directory" \
#    CARGO_BUILD_JOBS="4"

# SCCACHE
#export RUSTC_WRAPPER="/usr/bin/sccache"
#export SCCACHE_DIR="/home/user/.cache/sccache"
#export SCCACHE_CACHE_SIZE="100G"

# CCACHE
#export CCACHE_DIR="/home/user/.cache/ccache"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#eval /home/user/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# Dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT="true"


# Bedrock Linux
#alias wine="strat -r arch wine"
alias proton="STEAM_COMPAT_DATA_PATH='/home/user/.proton' PROTON_NO_ESYNC=1 PROTON_DUMP_DEBUG_COMMANDS='1' strat -r arch /home/user/.steam/steam/steamapps/common/Proton\ 5.13/proton run"

# SSH
#- eval (keychain --eval --agents ssh -Q --quiet ~/.ssh/id_ed25519 --nogui)
# content has to be in .config/fish/config.fish
# if it does not exist, create the file
#setenv SSH_ENV $HOME/.ssh/environment


#function start_agent                                                                                                                             
#    echo "Initializing new SSH agent ..."
#    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
#    echo "succeeded"
#    chmod 600 $SSH_ENV
#    . $SSH_ENV > /dev/null
#    ssh-add
#end

#function test_identities                                                                                                                         
#    ssh-add -l | grep "The agent has no identities" > /dev/null
#    if [ $status -eq 0 ]
#        ssh-add
#        if [ $status -eq 2 ]
#            start_agent
#        end
#    end
#end

#if [ -n "$SSH_AGENT_PID" ]
#    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
#    if [ $status -eq 0 ]
#        test_identities
#    end
#else
#    if [ -f $SSH_ENV ]
#        . $SSH_ENV > /dev/null
#    end
#    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
#    if [ $status -eq 0 ]
#        test_identities
#    else
#        start_agent
#    end
#end
