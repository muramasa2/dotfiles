#!/bin/bash -ux

THIS_DIR=$(cd $(dirname $0); pwd)
echo $THIS_DIR
mkdir ~/.config

for file in .zshrc .tmux.conf .fzf.zsh
do
    if [ -e "${HOME}/$file" ]; then
        echo "rm -f ~/$file"
        rm -f ~/$file
        echo "ln -sf $THIS_DIR/$file ~/$file"
        ln -sf $THIS_DIR/$file ~/$file
    fi
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
    # Check if running as root and adjust commands accordingly
    if [ "$EUID" -eq 0 ]; then
        APT_CMD="apt"
        DPKG_CMD="dpkg"
        MV_CMD="mv"
    else
        APT_CMD="sudo apt"
        DPKG_CMD="sudo dpkg"
        MV_CMD="sudo mv"
    fi
    
    # update apt & install essential libraries
    $APT_CMD update -y
    $APT_CMD install -y file zsh unzip make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev git libsndfile1-dev vim tmux liblapack-dev ffmpeg
    
    # install bat if not already installed
    if ! command -v bat &> /dev/null; then
        wget -q https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb
        $DPKG_CMD -i bat-musl_0.22.1_amd64.deb
        rm -f bat-musl_0.22.1_amd64.deb
    fi

    # install exa if not already installed
    if ! command -v exa &> /dev/null; then
        wget -q https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
        unzip -q exa-linux-x86_64-v0.10.0.zip -d exa
        $MV_CMD exa/bin/exa /usr/bin/
        rm -rf exa exa-linux-x86_64-v0.10.0.zip
    fi

    # install starship if not already installed
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
    fi
    mkdir -p $HOME/.config
    ln -sf $THIS_DIR/starship.toml $HOME/.config/starship.toml

    # install zoxide if not already installed
    if ! command -v zoxide &> /dev/null; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    # install fzf if not already installed
    if [ ! -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        echo y | ~/.fzf/install
    fi

    # install ripgrep if not already installed
    if ! command -v rg &> /dev/null; then
        RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[0-9.]+')
        curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RIPGREP_VERSION}_amd64.deb"
        $APT_CMD install -y ./ripgrep.deb
        rm -f ripgrep.deb
    fi

    # install uv if not already installed
    if ! command -v uv &> /dev/null; then
        echo "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        # Add uv to PATH for current session
        export PATH="$HOME/.local/bin:$PATH"
    else
        echo "uv is already installed"
    fi

    # install Node.js and Claude Code if not already installed
    if ! command -v node &> /dev/null; then
        echo "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
        $APT_CMD update
        $APT_CMD install -y nodejs
    else
        echo "Node.js is already installed"
    fi

    # install Claude Code if not already installed
    if ! command -v claude &> /dev/null; then
        echo "Installing Claude Code..."
        npm install -g @anthropic-ai/claude-code
    else
        echo "Claude Code is already installed"
    fi

    # setup Claude Code config (.claude directory)
    if [ -d "$THIS_DIR/.claude" ]; then
        echo "Setting up Claude Code config..."
        rm -rf ~/.claude
        ln -sf $THIS_DIR/.claude ~/.claude
        echo "Created symlink: ~/.claude -> $THIS_DIR/.claude"
    fi
fi

# tmux - only source if tmux is running and .tmux.conf exists
if [ -f ~/.tmux.conf ] && tmux list-sessions &> /dev/null; then
    tmux source ~/.tmux.conf
fi

# setting for fzf
ln -sf $THIS_DIR/.fzf.zsh $HOME/.fzf.zsh

# zsh-autosuggestions install if not already installed
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

# for docker completion
mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose \
     -o ~/.zsh/completion/_docker-compose

# install pyenv if not already installed
# Set PYENV_ROOT based on OS
if [ $(uname) = Darwin ]; then
    PYENV_ROOT="$HOME/.pyenv"
else
    PYENV_ROOT="/datamount/work/.pyenv"
fi

if [ ! -d "$PYENV_ROOT" ]; then
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
fi

# install pyenv-virtualenv if not already installed
if [ ! -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
fi

# Add pyenv to PATH if not already there
if ! grep -q "PYENV_ROOT" ~/.profile; then
    echo "export PYENV_ROOT=\"$PYENV_ROOT\"" >> ~/.profile
    echo "export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >> ~/.profile
    echo 'eval "$(pyenv init -)"' >> ~/.profile
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
fi

# Add pyenv to current PATH for this session
export PYENV_ROOT="$PYENV_ROOT"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install Python if not already installed
if ! pyenv versions | grep -q "3.11.0"; then
    pyenv install 3.11.0
fi
pyenv global 3.11.0

# poetry install if not already installed
if ! command -v poetry &> /dev/null; then
    if [ $(uname) = Darwin ]; then
        # On Mac, install poetry via brew to avoid SSL issues
        brew install poetry
    else
        # On Linux, use the official installer
        curl -sSL https://install.python-poetry.org | python3 -
    fi
fi

# git config
git config --global user.email "masasoundmusic@gmail.com"
git config --global user.name "muramasa2"

# Add conditional exec zsh to .profile if not already present
if ! grep -q "exec zsh" ~/.profile; then
    echo "" >> ~/.profile
    echo "# Only exec zsh if:" >> ~/.profile
    echo "# 1. We're in an interactive shell (PS1 is set)" >> ~/.profile
    echo "# 2. We're not already in zsh (ZSH_VERSION is not set)" >> ~/.profile
    echo "# 3. zsh is available" >> ~/.profile
    echo 'if [ -n "$PS1" ] && [ -z "$ZSH_VERSION" ] && command -v zsh >/dev/null 2>&1; then' >> ~/.profile
    echo "    exec zsh" >> ~/.profile
    echo "fi" >> ~/.profile
    echo "Added conditional exec zsh to ~/.profile"
else
    echo "exec zsh already present in ~/.profile, skipping"
fi