if [[ $(command -v exa) ]]; then
    alias exa="exa -a --icons --git -h -g"
    alias ls=exa

    # cdls
    cdls ()
    {
        \cd "$@" && exa
    }
else
    alias ls="ls -a"
    cdls ()
    {
        \cd "$@" && ls
    }
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# eval "$(nodenv init -)
eval "$(thefuck --alias)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# eval "$(colima start)"
if [[ $(command -v z) ]]; then
    alias cd="z"
fi
alias cat="bat"
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
