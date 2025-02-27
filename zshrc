#/────────────────────/p10k-init/────────────────────/#

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#/────────────────────/zinit/────────────────────/#

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

#/────────────────────/p10k/────────────────────/#

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#/────────────────────/completion/────────────────────/#

autoload -Uz compinit && compinit
zinit cdreplay -q
#setopt correct_all

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -l --color=always $realpath'

#/────────────────────/History/────────────────────/#

HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#/────────────────────/plugins/────────────────────/#

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

#/────────────────────/alias/────────────────────/#

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
alias fl='fzf-lovely'
alias gparted='sudo -E gparted'
alias cf='clear && fastfetch'

#/────────────────────/bindkey/────────────────────/#

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey "^[[3~" delete-char

#/────────────────────/Shell integrations/────────────────────/#

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

function fzf-lovely(){

	if [ "$1" = "h" ]; then
		fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
 	                echo {} is a binary file ||
	                 (bat --style=numbers --color=always {} ||
	                  highlight -O ansi -l {} ||
	                  coderay {} ||
	                  rougify {} ||
	                  cat {}) 2> /dev/null | head -500'

	else
	        fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
	                         echo {} is a binary file ||
	                         (bat --style=numbers --color=always {} ||
	                          highlight -O ansi -l {} ||
	                          coderay {} ||
	                          rougify {} ||
	                          cat {}) 2> /dev/null | head -500'
	fi
}
