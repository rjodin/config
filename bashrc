# .bashrc

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

alias cd_tmp='cd $(mktemp -d)'
alias rm_tmp='pwd >> ~/.pwd && cd && rm -rf $(cat ~/.pwd | tail -n 1)'

alias get_pwd='pwd | tee -a ~/.pwd'
alias cd_pwd='cd $(cat ~/.pwd | tail -n 1)'

reduce_path(){
    local full_path=$1
    local reduce_prefix=$(echo $full_path \
                           | sed 's|/home/rjodin|~|')
    # | sed 's|\(/[^/]*/\).*/.*\(/[^/]*/[^/]*/[^/]*\)$|\1...\2|'
    # return
    local prefix=$(echo $reduce_prefix | sed 's|^\([^/]*\)/.*$|\1|')
    local current_dir=$(echo $reduce_prefix | sed 's|^.*\(/[^/]*/[^/]*/[^/]*\)$|\1|')
    local suffix=$(echo $reduce_prefix | sed 's|^[^/]*\(/.*\)/[^/]*/[^/]*/[^/]*$|\1|')
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

date_file() {
    echo -ne "$(realpath ~/.bashrc_date_$(ps -o session --no-headers | head -n 1 | sed 's| *||'))"
}

prompt_fct(){

    local RET=$(echo $?" " | sed 's/^0 $//');
    local CURRENT_TIME=$(date +%s)
    local CURDIR="$(reduce_path "$(pwd)") "
    local DATE="$(date +%H:%M) "

    local DATE_FILE=$(date_file)
    local TIME=""
    if [ -f ${DATE_FILE} ]
    then
        local BASHRC_DATE=$(cat ${DATE_FILE})
        rm -f ${DATE_FILE}

        local elapse_time=$((${CURRENT_TIME} - ${BASHRC_DATE}))
        if [[ ${elapse_time} -gt 3600 ]]
        then
            TIME+="$((${elapse_time} / 3600)):"
            elapse_time=$((${elapse_time} % 3600))
        fi
        if [[ ${elapse_time} -gt 60 ]]
        then
            TIME+="$((${elapse_time} / 60)):"
            elapse_time=$((${elapse_time} % 60))
        fi
        TIME+="${elapse_time} "
    fi

    local COLOR_CYAN="\[\e[00;36m\]"
    local COLOR_CYAN_BOLD="\[\e[01;36m\]"
    local COLOR_DARK_GRAY="\[\e[00;90m\]"
    local COLOR_YELLOW="\[\e[00;33m\]"
    local COLOR_MAGENTA="\[\e[00;35m\]"
    local COLOR_RED_BOLD="\[\e[01;31m\]"
    local COLOR_GREEN="\[\e[00;32m\]"
    local COLOR_NONE="\[\e[0m\]"

    local CURBRANCH=$(git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1) /')
    local CURBRANCH_COLOR="${COLOR_YELLOW}"
    if $(git status --ignore-submodules=all 2> /dev/null | grep -q "modifi")
    then
        CURBRANCH_COLOR="${COLOR_MAGENTA}"
    fi

    local ENDLINE_CHAR="-"
    if [[ "${VK_ICD_FILENAMES}" != "" ]] || [[ "${OCL_ICD_FILENAMES}" != "" ]]
    then
        ENDLINE_CHAR="="
    fi

    [ -z $COLUMNS ] && COLUMNS=80;
    local NBLINE=$(($COLUMNS - ${#CURDIR} - ${#CURBRANCH} - ${#RET} - ${#DATE} - ${#TIME}))
    local ENDLINE=""
    for (( c=0; c<$NBLINE; c++ )) do ENDLINE+=${ENDLINE_CHAR}; done

    PS1=""
    PS1+="$COLOR_CYAN$DATE"
    PS1+="$COLOR_DARK_GRAY$TIME"
    PS1+="$COLOR_CYAN_BOLD$CURDIR"
    PS1+="$COLOR_GREEN$ICD_SET"
    PS1+="$CURBRANCH_COLOR$CURBRANCH"
    PS1+="$COLOR_RED_BOLD$RET"
    PS1+="$COLOR_CYAN$ENDLINE"
    PS1+="$COLOR_NONE\n\$ "

    # ring bell in tmux
    echo -ne "\a"
}

PROMPT_COMMAND='prompt_fct'

function before_command() {
    case "$BASH_COMMAND" in
        $PROMPT_COMMAND)
        ;;
        *)
            date +%s > "$(date_file)"
    esac
}
trap before_command DEBUG

