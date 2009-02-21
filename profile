###########
# GENERAL #
###########
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1
export HISTCONTROL=ignoredups # Ignores dupes in the history
export EDITOR='mate -w'  # OS-X SPECIFIC - TextMate, w is to wait for TextMate window to close

# bash completion settings (actually, these are readline settings)
bind "set completion-ignore-case on" # note: bind is used instead of setting these in .inputrc.  This ignores case in bash completion
bind "set bell-style none" # No bell, because it's damn annoying
bind "set show-all-if-ambiguous On" # this allows you to automatically show completion without double tab-ing

alias home='cd ~'
alias l='ls -lahG'
alias ls='ls -lahG'
alias dir='ls -lahG'
alias d='du -shx'
alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias docs='cd Documents/'
alias e='mate . &'
alias et='mate README app/ config/ db/ lib/ public/ test/ vendor/plugins &'

alias rm='rm -i'
alias mysql='/usr/local/mysql/bin/mysql -u root -p'
alias g='grep -i'  # Case insensitive grep
alias f='find . -iname'
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias top='top -o cpu'
alias systail='tail -f /var/log/system.log'
alias m='more'
alias df='df -h'

shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns

# Shows most used commands, cool script I got this from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# Turn on advanced bash completion if the file exists (get it here: http://www.caliban.org/bash/index.shtml#completion)
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# SSH Auto Completion of Remote Hosts
SSH_COMPLETE=( $(cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | egrep -v [0123456789]) )
complete -o default -W "${SSH_COMPLETE[*]}" ssh

# I got the following from, and mod'd it: http://www.macosxhints.com/article.php?story=20020716005123797
# The following aliases (save & show) are for saving frequently used directories
# You can save a directory using an abbreviation of your choosing. Eg. save ms
# You can subsequently move to one of the saved directories by using cd with
# the abbreviation you chose. Eg. cd ms  (Note that no '$' is necessary.)
if [ ! -f ~/.dirs ]; then  # if doesn't exist, create it
    touch ~/.dirs
fi

alias show='cat ~/.dirs'
save (){
    command sed "/!$/d" ~/.dirs > ~/.dirs1; \mv ~/.dirs1 ~/.dirs; echo "$@"=\"`pwd`\" >> ~/.dirs; source ~/.dirs ; 
}
source ~/.dirs  # Initialization for the above 'save' facility: source the .sdirs file
shopt -s cdable_vars # set the bash option so that no '$' is required when using the above facility

##########
# Prompt #
##########
function set_prompt {
    local BLACK="\[\033[0;30m\]"
    local BLUE="\[\033[0;34m\]"
    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local RED="\[\033[0;31m\]"
    local PURPLE="\[\033[0;35m\]"
    local LIGHT_GRAY="\[\033[0;37m\]"
    local DARK_GRAY="\[\033[1;30m\]"
    local LIGHT_BLUE="\[\033[1;34m\]"
    local LIGHT_GREEN="\[\033[1;32m\]"
    local LIGHT_CYAN="\[\033[1;36m\]"
    local LIGHT_RED="\[\033[1;31m\]"
    local LIGHT_PURPLE="\[\033[1;35m\]"
    local YELLOW="\[\033[1;33m\]"
    local WHITE="\[\033[1;37m\]"
    local NO_COLOUR="\[\033[0m\]"

    if [ "$HOSTNAME" = "YOUR LOCAL USER HERE (user.local)" ]; then
        local HOST_COLOUR=$LIGHT_RED
    fi

    local user="$WHITE[$LIGHT_RED\u$WHITE@$HOST_COLOUR$HOSTNAME$WHITE]"

if [ $(parse_git_branch) ] ; then
    PS1="${user}\$WHITE[$LIGHT_BLUE`date '+%X'`$WHITE]$NO_COLOUR\

\e[0;35m\]$(parse_git_branch)\[\e[m\]
$WHITE($YELLOW\w$WHITE)\

$ $NO_COLOUR"
else
    PS1="${user}\$WHITE[$LIGHT_BLUE`date '+%X'`$WHITE]$NO_COLOUR\

$WHITE($YELLOW\w$WHITE)\

$ $NO_COLOUR"
fi
}
export PROMPT_COMMAND=set_prompt


###############
# EXTERNAL IP #
###############
function pad {
    string="$1"; num="$2"; count=$(echo -n "$string" | wc -c); ((count += 0))
    while (( count < num )); do string=" $string"; ((count += 1)); done
    echo -n "$string"
}
function showip {
    idx=0; mode="media"; info=$(ifconfig | fgrep -B 2 netmask)
    for i in $info; do
        case "$mode" in
            media)
                case "$i" in
                    en0*)   media[$idx]="Ethernet"; mode="ip";;
                    en1*)   media[$idx]="WiFi"; mode="ip";;
                    en*)    media[$idx]=""; mode="ip";;
                esac;;
            ip)
                if [[ "$i" == [0-9]*.[0-9]*.[0-9]*.[0-9]* ]]; then
                    ip[$idx]="$i"; ((idx += 1)); mode="media"
                fi;;
        esac
    done
    for ((i=0; i < ${#media[*]}; i++)); do
        if [[ $ip ]]; then
            ip=$(pad ${ip[$i]:-Unknown} 15)
            echo "Internal  $ip    (via ${media[$i]})"
        fi
    done
    ip=$(curl -s www.whatismyip.com/automation/n09230945.asp)
    ip=$(pad ${ip:-Unknown} 15)
    echo "External  $ip"
}
alias showip=showip


#########
# RAILS #
#########
alias ss='script/server'
alias sc='script/console'
alias a='autotest -rails'

# make sure you have the right chmod (755):
complete -C ~/rake-completion.rb -o default rake

#######
# GIT #
#######
alias gb="git branch"
alias gba="git branch -a"
alias gc="git commit -v"
alias gd="git diff | mate"
alias gl="git pull --rebase"
alias gp="git push origin HEAD"
alias gcp="git cherry-pick"
alias gst="git status"
alias ga="git add"
alias gr="git rm"
alias gu="git pull --rebase && git push origin HEAD"

# make sure you have the right chmod (755):
source ~/git-bash-completion.sh

# this will give you a colored bash:
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

###########
# GIT-SVN #
###########
#
# srebase => svn update
# scommit -> svn commit

# check if there are no changes and untracked files present
function nothing_changed_something_untracked {
  [[ $(git status 2> /dev/null | tail -n1) != 'nothing added to commit but untracked files present (use "git add" to track)' ]]; true
}
# check if there are changes and untracked files present BUGGY
  function something_changed_something_untracked {
[[ $(git status 2> /dev/null | tail -n1) != 'no changes added to commit (use "git add" and/or "git commit -a")' ]]; true
}
# check if there is something to stash
function something_to_stash {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]]; true
}
# check if on master branch
function on_master {
  [[ $(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/") == "master" ]]; true
}

#svn update
function git_rebase {
if on_master; then
  git checkout master
elif something_to_stash; then
  git stash save svntmp &&
  if nothing_changed_something_untracked | something_changed_something_untracked; then
    echo 'there are untracked files present (use "git add" to track)'
    else
    git svn rebase && git stash apply svntmp && git stash drop svntmp
  fi
  else
  git svn rebase
fi
}
alias srebase=git_rebase

#svn commit
function git_commit {
if ! on_master; then
  git checkout master
elif something_to_stash; then
  git stash save svntmp &&
  if nothing_changed_something_untracked | something_changed_something_untracked; then
    echo 'there are untracked files present (use "git add" to track)'
    exit 0
    else
    git svn dcommit && git stash apply svntmp && git stash drop svntmp
  fi
  else
  git svn dcommit
fi
}
alias scommit=git_commit