# vi:syntax=sh

alias ls="ls --color"
alias la="ls -a"
alias ll="ls -lh"
alias lla="ls -lha"

alias vim="nvim"

# Termite compat
alias ssh="TERM=xterm-color ssh"

alias gradle="./gradlew"

alias gitls="git status --short ."

alias reload="source $HOME/.bashrc"

alias pip-upgrade-venv="pip freeze | cut -d'=' -f1 | xargs -n1 pip install -U"
