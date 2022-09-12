#!/bin/bash -ux

THIS_DIR=$(cd $(dirname $0); pwd)

for file in .zshrc .tmux.conf .fzf.zsh
do
    [ ! -e "${HOME}/$file" ] && cp $file ~/
done


cd $HOME

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

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    which brew >/dev/null 2>&1 && brew doctor

    # for vscode
    ln -sf $THIS_DIR/settings.json "${HOME}/Library/Application Support/Code/User/settings.json"
elif [ $(uname) = Linux ]; then  # WSL
    # update apt & install essential libraries
    sudo apt update -y
    sudo apt-get install -y build-essential curl file git zsh
    
    # install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zprofile
    echo "source $HOME/.zprofile" >> ~/.profile
    echo "/bin/zsh" >> ~/.profile
fi

source ~/.zprofile
# brew本体のアップデート
brew update

# パッケージのアップデート
brew upgrade --cask

# Brewfileの中身をインストール
brew bundle --file $THIS_DIR/Brewfile
brew cleanup

# tmux
tmux source ~/.tmux.conf

# setting for fzf
ln -sf $THIS_DIR/.fzf.zsh $HOME/.fzf.zsh

# zsh-autosuggestions install
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# for docker completion
mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose \
     -o ~/.zsh/completion/_docker-compose

# install pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
/bin/zsh -c "pyenv install 3.9.1"
/bin/zsh -c "pyenv shell 3.9.1"

# poetry install
/bin/zsh -c "curl -sSL https://install.python-poetry.org | python3 -"
/bin/zsh -c "pyenv global 3.9.1"