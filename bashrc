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
alias difff='diff --color=always --suppress-common-line -y -W$COLUMNS'

# for rust-analyzer initially
PATH=~/.local/bin:$PATH

reduce_path(){
    local full_path=$1
    local reduce_prefix=$(echo $full_path \
                           | sed 's|/home/rjodin|~|')
    # | sed 's|\(/[^/]*/\).*/.*\(/[^/]*/[^/]*/[^/]*\)$|\1...\2|'
    # return
    local prefix=$(echo $reduce_prefix | sed 's|^\([^/]*/[^/]*\)/.*$|\1|')
    local current_dir=$(echo $reduce_prefix | sed 's|^.*\(/[^/]*/[^/]*\)$|\1|')
    local suffix=$(echo $reduce_prefix | sed 's|^[^/]*/[^/]*\(/.*\)/[^/]*/[^/]*$|\1|')
    local reduce_suffix=$(echo $suffix | sed -r 's|/(.)[^/]*|/\1|g')
    # echo -ne "$prefix\n$suffix\n$reduce_suffix\n$current_dir\n"
    # return
    if [[ $suffix == $reduce_prefix ]]
    then
        echo $reduce_prefix
    elif [[ $suffix == $prefix$current_dir ]]
    then
        echo $prefix$current_dir
    else
        echo $prefix$reduce_suffix$current_dir
    fi
}

prompt_fct(){

    local RET=$(echo $?" " | sed 's/^0 $//');
    local CURDIR=$(reduce_path "$(pwd)")
    local HOSTNAME=$(hostname -s)
    local DATE=$(date +%H:%M)
    local GITSTATUS=""
    local ICD_SET=""

    if $(git status --ignore-submodules=all 2> /dev/null | grep -q "modifi")
    then
        GITSTATUS="M"
    fi

    if [[ "${VK_ICD_FILENAMES}" != "" ]] || [[ "${OCL_ICD_FILENAMES}" != "" ]]
    then
        ICD_SET="ICD "
    fi

    local CURBRANCH=$(git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1) /')

    local COLOR_CYAN="\[\e[00;36m\]"
    local COLOR_CYAN_BOLD="\[\e[01;36m\]"
    local COLOR_YELLOW="\[\e[00;33m\]"
    local COLOR_YELLOW_BOLD="\[\e[01;33m\]"
    local COLOR_RED_BOLD="\[\e[01;31m\]"
    local COLOR_GREEN="\[\e[00;32m\]"
    local COLOR_NONE="\[\e[0m\]"

    local PS1_ADDED_CHAR=" []  "

    [ -z $COLUMNS ] && COLUMNS=80;
    local NBLINE=$(($COLUMNS - ${#GITSTATUS} - ${#HOSTNAME} - ${#CURDIR} - ${#CURBRANCH} - ${#RET} - ${#DATE} - ${#PS1_ADDED_CHAR} - ${#ICD_SET}))
    local ENDLINE=""
    for (( c=0; c<$NBLINE; c++ )) do ENDLINE+="-"; done

    PS1=""
    PS1+="$COLOR_CYAN_BOLD$DATE "
    PS1+="$COLOR_CYAN[$HOSTNAME] "
    PS1+="$COLOR_CYAN_BOLD$CURDIR "
    PS1+="$COLOR_GREEN$ICD_SET"
    PS1+="$COLOR_RED_BOLD$GITSTATUS"
    PS1+="$COLOR_YELLOW$CURBRANCH"
    PS1+="$COLOR_RED_BOLD$RET"
    PS1+="$COLOR_CYAN$ENDLINE"
    PS1+="$COLOR_NONE\n\$ "
}

PROMPT_COMMAND='prompt_fct'
