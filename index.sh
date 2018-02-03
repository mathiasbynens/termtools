#!/bin/bash

# Let's ensure it accepts colors
export CLICOLOR=TRUE

# We need to determine the source from where the source is running
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# let's also see if this is running on a TTY
TTY="0"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  TTY="1"
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) TTY="1";;
  esac
fi

# Git completition
#
# This will enable git completition in terminal, for branches and commands.
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# let's ensure the right fonts are available
. $DIR/ensure-fonts.sh

# echo $SOURCE
node $DIR/index.js $SOURCE $TTY $HOSTNAME $HOME $IP $SESSION_TYPE 
# node inspect $DIR/index.js $SOURCE $TTY $HOSTNAME $HOME $IP $SESSION_TYPE 
source $DIR/exported.sh
# sudo bash -c "echo 'source $DIR/exported.sh' > ~/.bash_profile"