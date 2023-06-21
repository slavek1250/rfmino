# @file bash-setup.sh
#
# @note Copyright (c) 2023 rfmino

function setup_git()
{
    source "$(dirname -- "${BASH_SOURCE[0]}")/git-prompt.sh"
    export GIT_PS1_SHOWDIRTYSTATE=1
    export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\[\033[1;36m\]$(__git_ps1 " (%s)")\[\033[00m\]\n\$ '
}

function setup_persistent_history()
{
    export PROMPT_COMMAND='history -a'
    export HISTFILE=/commandhistory/.bash_history
}

setup_git
setup_persistent_history
