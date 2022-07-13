#!/bin/bash -ux

THIS_DIR=$(cd $(dirname $0); pwd)

cd $HOME

for file in .zshrc .tmux.conf .vimrc
do
    [ ! -e $file ] && ln -sf dotfiles/$file .
done

# starship config
mkdir -p $HOME/.config
ln -sf $THIS_DIR/starship.toml $HOME/.config/starship.toml

# setting for fzf
ln -sf $THIS_DIR/.fzf.zsh $HOME/.fzf.zsh

# setting for git
ln -sf $THIS_DIR/git/.gitconfig $HOME/.gitconfig


# zinit install
sh -c "$(curl -fsSL https://git.io/zinit-install)"
source ~/.zshrc
zinit self-update

if [ $(uname) = Darwin ]; then 
    # mac
    mkdir ~/Pictures/ScreenShots/
    defaults write com.apple.screencapture location ~/Pictures/
    # ファインダーにホームディレクトリを表示
    chflags nohidden ~/
    # 隠しファイルを表示
    defaults write com.apple.finder AppleShowAllFiles TRUE
    # 共有フォルダで .DS_Storeファイルを作成しない
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true

    xcode-select --install
    echo "installing Homebrew ..."
    which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    which brew >/dev/null 2>&1 && brew doctor

    # brew本体のアップデート
    brew update

    # パッケージのアップデート
    brew upgrade
    brew upgrade --cask

    # Brewfileの中身をインストール
    brew bundle --file $THIS_DIR/Brewfile

    brew cleanup

    # for vscode
    ln -sf $THIS_DIR/settings.json "${HOME}/Library/Application Support/Code/User/settings.json"

fi

# for docker completion
mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose \
     -o ~/.zsh/completion/_docker-compose

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf

cd $THIS_DIR

source ~/.zshrc

# install rbenv pyenv nodenv
git clone git://github.com/yyuu/pyenv.git ~/.pyenv

pyenv install 3.9.9

# poetry install
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -