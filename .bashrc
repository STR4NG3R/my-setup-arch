#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export JAVA_HOME=/usr/lib/jvm/default

#if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#    tmux attach -t default || tmux new -s default
#fi


alias ls='ls --color=auto'
alias install='pacman -S'
alias remove='pacman -R'
alias update='pacman -Syu'
alias remove='pacman -Scc'
alias auto_clean='sudo pacman -Qcc'
PS1='[\u@\h \W]\$ '
#TERM=alacritty
