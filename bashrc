# .bashrc

setxkbmap -layout fr

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias emacs='emacs -nw'
alias fge='fg %emacs'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias diff='diff --color=always'
alias rm='rm -i'
alias tree='tree -C'

PATH=~/.local/bin:$PATH

reduce_path(){
    echo $1 | sed 's/\/home\/rjodin/~/' | sed 's/\(\/[^\/]*\/\).*\/.*\(\/[^\/]*\/[^\/]*\/[^\/]*\)$/\1...\2/'
}

prompt_fct(){

	RET=$(echo $?" " | sed 's/^0 $//');
	CURDIR=$(reduce_path $(pwd))
	WHOAMI=$(echo $(whoami) | sed 's/rjodin/®/')
	HOSTNAME=$(hostname -s)
	DATE=$(date +%H:%M)
	GITSTATUS=""

	if $(git status --ignore-submodules=all 2> /dev/null | grep -q "modifi")
	then
	    GITSTATUS="M"
	fi
	CURBRANCH=$(git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1) /')

	COLOR_CYAN="\[\e[00;36m\]"
	COLOR_CYAN_BOLD="\[\e[01;36m\]"
	COLOR_YELLOW="\[\e[00;33m\]"
	COLOR_YELLOW_BOLD="\[\e[01;33m\]"
	COLOR_RED_BOLD="\[\e[01;31m\]"
	COLOR_GREEN="\[\e[00;32m\]"
	COLOR_NONE="\[\e[0m\]"

	[ -z $COLUMNS ] && COLUMNS=80;
	NBLINE=$(($COLUMNS - ${#GITSTATUS} - ${#HOSTNAME} - ${#WHOAMI} - ${#CURDIR} - ${#CURBRANCH} - ${#RET} - ${#DATE} - ${#SDK_PATH} - ${#UPMEM_PROFILE_SET} - 6))
	ENDLINE=""
	for (( c=1; c<=$NBLINE; c++ )) do ENDLINE="$ENDLINE-"; done

	PS1="$COLOR_CYAN_BOLD$DATE $COLOR_CYAN[$WHOAMI@$HOSTNAME] $COLOR_CYAN_BOLD$CURDIR $COLOR_RED_BOLD$GITSTATUS$COLOR_YELLOW$CURBRANCH$COLOR_RED_BOLD$RET$COLOR_CYAN$ENDLINE$COLOR_NONE\n\$ "
}

PROMPT_COMMAND='prompt_fct'
