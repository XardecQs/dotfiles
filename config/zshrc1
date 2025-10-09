#/────────────────────/p10k-init/────────────────────/#

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#/────────────────────/zinit/────────────────────/#

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git  "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

#/────────────────────/completion/────────────────────/#

autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zinit cdreplay -q
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always $realpath'

#/────────────────────/History/────────────────────/#

HISTSIZE=50000
HISTFILE=~/.local/share/zsh/history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#/────────────────────/Shell integrations/────────────────────/#

export EDITOR=nvim
eval "$(fzf --zsh)" 
eval "$(zoxide init --cmd cd zsh)"

#/────────────────────/plugins/────────────────────/#

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light nix-community/nix-zsh-completions
zinit light Aloxaf/fzf-tab

#/────────────────────/alias/────────────────────/#

alias cp='cp --reflink=auto'
alias ls='lsd'
alias c='clear'
alias umatrix='unimatrix -s 95 -f'
alias ll='lsd -lh'
alias la='lsd -a'
alias lla='lsd -la'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias mirrors="sudo reflector --verbose --country Peru,Chile,Ecuador,Brazil,US,Colombia,Argentina --protocol https --latest 25 --sort rate --save /etc/pacman.d/mirrorlist"
alias cf='clear && fastfetch'
alias cff='clear && fastfetch --config examples/13.jsonc'
alias q='exit'
alias syu='yay -Syu'
alias codepwd='code "$(pwd)"'
alias napwd='nautilus "$(pwd)" &> /dev/null & disown'
alias ordenar='/home/xardec/Proyectos/Scripts/sh/ordenar.sh'
alias desordenar='/home/xardec/Proyectos/Scripts/sh/desordenar.sh'
alias snvim='sudo -E nvim'
alias dots='cd ~/.dotfiles && codepwd && q'
alias dotsn='cd ~/.dotfiles && nvim'
alias dopwd='dolphin $(pwd)'

#/────────────────────/bindkey/────────────────────/#

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey "^[[3~" delete-char

#/────────────────────/p10k/────────────────────/#

mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/p10k.zsh" ]] || source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/p10k.zsh"
