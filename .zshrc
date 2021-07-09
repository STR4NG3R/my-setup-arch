# tmux has-session -t development
# if [ $? != 0 ]
# then
#   tmux new-session -s development
# fi
# tmux attach -t development
# clear

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


plugins=(
  git
  history
  tmux
  systemd
  sudo
  fzf
  gcloud
  compleat
  zsh-interactive-cd
)

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

export PATH=$PATH:/opt/texlive/bin:/home/str4ng3r/.local/bin:~/.config/scripts:${HOME}/.config/rofi/bin
export ZSH="$HOME/.oh-my-zsh"
export ANDROID_HOME="$HOME/Android/Sdk"
export QT_QPA_PLATFORMTHEME="qt5ct"
export JAVA_HOME=/usr/lib/jvm/default
export JDK_HOME=$JAVA_HOME
export SSHFS=~/Documents/SSHFS

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


function prependfile {
  echo $1|cat - $2 > /tmp/out && mv /tmp/out $2
}

function codi() {
   local syntax="${1:-python}"
   shift
   nvim -c \
     "let g:startify_disable_at_vimenter = 1 |\
     set bt=nofile ls=0 noru nonu nornu |\
     hi CodiVirtualText guifg=red
     hi ColorColumn ctermbg=NONE |\
     hi VertSplit ctermbg=NONE |\
     hi NonText ctermfg=0 |\
     Codi $syntax" "$@"
}

function connect_remote_server {
  ssh -i ~/.ssh/credentials/${1}/${2} ${3}
}

function download_mp3 {
  regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  link=$(xclip -o)
  if [[ $link =~ $regex ]]
  then 
    notify-send "Starting Download ${link}"
    cwd=$(pwd)
    cd $HOME/Music/
    youtube-dl -x --embed-thumbnail --audio-format mp3 $link
    notify-send "Downloaded"
    notify-send 
    cd $cwd
else 
  notify-send "Invalid Link"
  fi
}

function sshfs_withkeys() {
  sshfs ${1}@${2}:/ ${HOME}/Documents/SSHFS/  -i ${3} 
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
alias df='df -hT'
alias free='free -h'
alias gen_dep_pip='pip freeze > requierements.txt '
alias gnvim='gnvim --disable-ext-tabline'
alias ctags='uctags'
alias myip='curl ifconfig.me'
alias music='tmux new-session -s music "tmux source-file ~/.config/ncmpcpp/tsession"'
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
