export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export TERM=xterm-256color
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
export HISTFILE="$HOME/.bash_history"
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

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
if [[ $(command -v z) ]]; then
    alias cd="z"
fi
if [[ $(command -v bat) ]]; then
    alias cat="bat"
fi

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# load settings for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# 補完候補が複数ある時に、一覧表示
setopt auto_list
# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
setopt auto_menu
# カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt always_last_prompt    
# 日本語ファイル名等8ビットを通す
setopt print_eight_bit       
# 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt extended_glob   
# 明確なドットの指定なしで.から始まるファイルをマッチ
setopt globdots        
# 補完候補が複数ある時に、一覧表示
setopt auto_list
# ディレクトリ名で移動可能
setopt auto_cd
# ^D でシェルを終了しない
setopt ignore_eof
# 補完時にヒストリを自動的に展開する
setopt hist_expand
# 補完候補一覧でファイルの種別を識別マーク表示
setopt list_types
# カッコの対応などを自動的に補完
setopt auto_param_keys
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
# 語の途中でもカーソル位置で補完
setopt complete_in_word
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
# 履歴をすぐに追加する（通常はシェル終了時）
setopt inc_append_history
# 重複したコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# 履歴の共有
setopt share_history
# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store
# 環境変数を補完
setopt AUTO_PARAM_KEYS
# ビープを無効にする
setopt no_beep
setopt no_hist_beep
setopt no_list_beep

# 補完方法毎にグループ化する。
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
# 補完侯補をメニューから選択する。
# select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2
# 補完候補に色を付ける。
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# 補完候補がなければより曖昧に候補を探す。
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
# r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both

# 補完候補
# _oldlist 前回の補完結果を再利用する。
# _complete: 補完する。
# _match: globを展開しないで候補の一覧から補完する。
# _history: ヒストリのコマンドも補完候補とする。
# _ignored: 補完候補にださないと指定したものも補完候補とする。
# _approximate: 似ている補完候補も補完候補とする。
# _prefix: カーソル以降を無視してカーソル位置までで補完する。
#zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
zstyle ':completion:*' completer _complete _ignored

# 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
# 詳細な情報を使わない
zstyle ':completion:*' verbose no
HISTSIZE=10000
SAVEHIST=10000
# ignore unnecessary history.
# Ref: https://www.m3tech.blog/entry/dotfiles-bonsai
zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|z|jj?|lazygit|la|ll|ls|exa)($| )" ]]
}
cd /data/work
