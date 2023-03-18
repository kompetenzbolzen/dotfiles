# vi:syntax=sh

function back() { cd "$OLDPWD"; }

function cs() {
	cd "$@" || return $?
	ls --color=auto
}

alias ls="ls --color"
alias la="ls -a"
alias ll="ls -lh"
alias lla="ls -lha"

if which nvim > /dev/null 2>&1 && [ ! "$FORCE_VANILLA_VIM" = "yes" ] ; then
	alias vim="nvim"
fi

# Termite compat
alias ssh="TERM=xterm-color ssh"

alias gradle="./gradlew"

alias gitls="git status --short ."

alias reload="source \$HOME/.bashrc"

alias pip-upgrade-venv="pip freeze | cut -d'=' -f1 | xargs -n1 pip install -U"

alias vybld='docker pull vyos/vyos-build:equuleus && docker run --rm -it \
    -v "$(pwd)":/vyos \
    -v "$HOME/.gitconfig":/etc/gitconfig \
    -v "$HOME/.bash_aliases":/home/vyos_bld/.bash_aliases \
    -v "$HOME/.bashrc":/home/vyos_bld/.bashrc \
    -w /vyos --privileged --sysctl net.ipv6.conf.lo.disable_ipv6=0 \
    -e GOSU_UID=$(id -u) -e GOSU_GID=$(id -g) \
    vyos/vyos-build:equuleus bash'

for i in $(seq 10); do
	DOTS='.'
	for _ in $(seq $i); do
		DOTS+="."
	done

	PTH=''
	for _ in $(seq $i); do
		PTH+="../"
	done

	alias $DOTS="cd $PTH"
	unset DOTS PTH
done
