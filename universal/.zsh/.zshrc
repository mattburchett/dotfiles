if [ "`uname -a | grep Darwin`" ]
  then
    export ZSH=Users
  else
    export ZSH=home
fi

source /$ZSH/.zsh/history
source /$ZSH/.zsh/alias
source /$ZSH/.zsh/exports
source /$ZSH/.zsh/bindkeys
source /$ZSH/.zsh/completion
source /$ZSH/.zsh/setopt
source /$ZSH/.zsh/zsh-syntax-highlight/zsh-syntax-highlighting.zsh
source /$ZSH/.zsh/interactive
source /$ZSH/.zsh/prompt

if [[ $(whoami) =~ ^(matthew|contegix)$ ]]
  then
    source /$ZSH/.zsh/contegix
fi
