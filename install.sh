#!/bin/bash -ux

THIS_DIR=$(cd $(dirname $0); pwd)

for file in .zshrc .tmux.conf
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

    which brew >/dev/null 2>&1 && brew doctor

    # for vscode
    ln -sf $THIS_DIR/settings.json "${HOME}/Library/Application Support/Code/User/settings.json"
elif [ $(uname) = Linux ]; then  # WSL
    # update apt & install essential libraries
    sudo apt update -y
    sudo apt-get install -y build-essential curl file git zsh
    
    # change default shell into zsh
    chsh -s $(which zsh)
    
    # install homebrew
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zprofile
    source ~/.zprofile

fi

exec -l $(which zsh)

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
git clone git://github.com/yyuu/pyenv.git ~/.pyenv
pyenv install 3.9.0
pyenv shell 3.9.0

# poetry install
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -