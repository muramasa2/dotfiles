#!/bin/bash -ux

THIS_DIR=$(cd $(dirname $0); pwd)

mkdir ~/.config
ln -s $THIS_DIR/starship.toml ~/.config/starship.toml

for file in .zshrc .tmux.conf .fzf.zsh
do
    [ ! -e "${HOME}/$file" ] && ln -s $THIS_DIR/$file ~/$file
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

    source ~/.zprofile
    # brew本体のアップデート
    brew update

    # パッケージのアップデート
    brew upgrade --cask

    # Brewfileの中身をインストール
    brew bundle --file $THIS_DIR/Brewfile
    brew cleanup
elif [ $(uname) = Linux ]; then  # WSL
    # update apt & install essential libraries
    sudo apt update -y
    sudo apt install -y file zsh unzip make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev git libsndfile1-dev vim tmux liblapack-dev ffmpeg
    
    # install bat
    wget https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb
    sudo dpkg -i bat-musl_0.22.1_amd64.deb

    # install exa
    wget https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
    unzip exa-linux-x86_64-v0.10.0.zip -d exa
    sudo mv exa/bin/exa /usr/bin/

    # install starship
    echo y | curl -sS https://starship.rs/install.sh | sh
    mkdir $HOME.config
    ln -s $THIS_DIR/starship.toml $HOME/.config/starship.toml

    # install zoxide
    echo y | curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

    # install fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    echo y | ~/.fzf/install

    # install ripgrep
    RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[0-9.]+')
    curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RIPGREP_VERSION}_amd64.deb"
    sudo apt install -y ./ripgrep.deb

fi

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
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

echo "export PYENV_ROOT="$HOME/.pyenv"" >> ~/.profile
echo "export PATH="$PYENV_ROOT/bin:$PATH"" >> ~/.profile

source ~/.profile
pyenv install 3.9.1
pyenv global 3.9.1
pyenv shell 3.9.1

# install thefuck
pip3 install thefuck --user
echo "eval "$(thefuck --alias)""  >> ~/.zshrc

# poetry install
curl -sSL https://install.python-poetry.org | python3 -

# git config
git config --global user.email "masasoundmusic@gmail.com"
git config --global user.name "muramasa2"
echo "exec zsh" >> ~/.profile