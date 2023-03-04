if [ -f "/usr/share/defaults/etc/profile" ]
  then source /usr/share/defaults/etc/profile
fi

alias rm="rm -I"
alias la="ls -a"
alias ll="ls -l"
alias ..="cd .."

alias copy='xclip -sel clip'
alias cmd='compgen -c | fzf'

alias vpn='sudo systemctl start openvpn-pritunl.service'
alias stopvpn='sudo systemctl stop openvpn-pritunl.service'
alias vi='nvim'
alias vim='nvim'

export EDITOR=nvim
export TERM=xterm
export PATH="$HOME/.cabal/bin/:$PATH"
export NIXPKGS_ALLOW_UNFREE=1

#export TERM=xterm-256color
#eval '$(dircolors ~/.dir_colors)'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# prevent hang on Ctrl-S
stty -ixon

#bind '"\C-f":"$(compgen -c | sort -u | fzf)\n"'
#bind '"\C-b":"git branch\n"'
#bind 'set show-mode-in-prompt on'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f "~/.git-completion.bash" ]
  then source "~/.git-completion.bash"
fi

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=50000
HISTFILESIZE=10000

shopt -s histappend

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

eval "$(direnv hook bash)"

if [ -f "$HOME/.fehbg" ]
  then source ~/.fehbg
fi

# should be put in xinit file to be honest but this works temporarily
#xmodmap ~/.xmodmaprc

# Sexy Solarized Bash Prompt, inspired by "Extravagant Zsh Prompt"
# Customized for the Solarized color scheme by Sean O'Neil
if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then TERM=gnome-256color; fi
if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      BASE03=$(tput setaf 234)
      BASE02=$(tput setaf 235)
      BASE01=$(tput setaf 240)
      BASE00=$(tput setaf 241)
      BASE0=$(tput setaf 244)
      BASE1=$(tput setaf 245)
      BASE2=$(tput setaf 254)
      BASE3=$(tput setaf 230)
      YELLOW=$(tput setaf 136)
      ORANGE=$(tput setaf 166)
      RED=$(tput setaf 160)
      MAGENTA=$(tput setaf 125)
      VIOLET=$(tput setaf 61)
      BLUE=$(tput setaf 33)
      CYAN=$(tput setaf 37)
      GREEN=$(tput setaf 64)
    else
      BASE03=$(tput setaf 8)
      BASE02=$(tput setaf 0)
      BASE01=$(tput setaf 10)
      BASE00=$(tput setaf 11)
      BASE0=$(tput setaf 12)
      BASE1=$(tput setaf 14)
      BASE2=$(tput setaf 7)
      BASE3=$(tput setaf 15)
      YELLOW=$(tput setaf 3)
      ORANGE=$(tput setaf 9)
      RED=$(tput setaf 1)
      MAGENTA=$(tput setaf 5)
      VIOLET=$(tput setaf 13)
      BLUE=$(tput setaf 4)
      CYAN=$(tput setaf 6)
      GREEN=$(tput setaf 2)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    # Linux console colors. I don't have the energy
    # to figure out the Solarized values
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

PS1="\[$BASE01\]\t\[$BLUE\][\h]\[$GREEN\][\u] \[$CYAN\]\w\[$GREEN\] \$ \[$RESET\]"

