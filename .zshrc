if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM=alacritty
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="agnoster"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export JAVA_HOME=/usr/lib/jvm/default
export JDK_HOME=$JAVA_HOME
export PATH=$HOME/.config/rofi/bin:$PATH

#if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#    tmux attach -t default || tmux new -s default
#fi

function gitpush {
  echo "Message: "
  read message
  git add .
  git commit -m "${message}"
  if [ -n "$(git status - porcelain)" ];
  then
    echo "Its clean";
  else 
    git status
    echo "Push"
    git push -u origin master
  fi
}

alias ls='ls --color=auto'
alias install='trizen -S --noedit'
alias remove='trizen -R --noedit'
alias auto_clean='trizen -R $(trizen -Qdtq) --noedit'
alias update_mirrors='trizen -Syy --noedit'
alias update='trizen -Syu --noedit'
alias list_update='trizen -Qu'
alias clean_cache='trizen -Scc --noedit'
alias search='trizen -Ss'
alias trizenskip='trizen -S --skipinteg --noedit'
alias download_mp3='youtube-dl -x --embed-thumbnail --audio-format mp3'
alias df='df -hT'
alias free='free -h'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

