# Mac での環境構築

## 前提条件

### Xcode のインストール

[URL](https://itunes.apple.com/jp/app/xcode/id497799835?ls=1&mt=12)

### VSCode インストール（任意）

[URL](https://code.visualstudio.com/download)

#### code コマンドの PATH への追加

VSCode でコマンドパレットを開く（⇧⌘P）
表示されたコマンドパレットに shell command と入力。
インストールとアンインストールのオプションが表示された。

「シェルコマンド:PATH 内に'code'コマンドをインストールします」を選択。

#### VSCode 拡張機能インストール

以下をインストール

- Pylance
- Remote - SSH

## 実行方法

```bash
cd dotfiles
./install.sh
```

このスクリプトは以下をインストール・設定します：

### 共通ツール
- **zsh** 設定ファイル (.zshrc, .tmux.conf, .fzf.zsh) のシンボリックリンク作成
- **fzf** - ファジーファインダー
- **tmux** - ターミナルマルチプレクサ
- **pyenv** + **pyenv-virtualenv** - Python バージョン管理
  - Mac: `$HOME/.pyenv`
  - Linux: `/datamount/work/.pyenv`
  - Python 3.11.0 をグローバルに設定
- **poetry** - Python パッケージ管理（Mac では brew、Linux では公式インストーラー）
- **Docker Compose** 用の zsh 補完
- **zsh-autosuggestions** - コマンド候補表示
- Git 設定（user.email と user.name）
- .profile への zsh 自動起動設定

### Mac 固有の設定
- スクリーンショット保存先: `~/Pictures/`
- ホームディレクトリの表示
- 隠しファイルの表示
- ネットワークストアで .DS_Store を作成しない
- **Xcode Command Line Tools** のインストール
- **Homebrew** のインストールと設定
- VSCode 設定ファイルのシンボリックリンク作成
- **Brewfile** からのパッケージ一括インストール（bat, eza, ripgrep, starship, zoxide, tmux など）

### Linux (WSL) 固有の設定
- **必須開発ライブラリ** のインストール（build-essential, libssl-dev, git, vim, tmux, ffmpeg など）
- **bat** - cat の代替（個別ダウンロード）
- **exa** - ls の代替（個別ダウンロード）
- **starship** - プロンプトカスタマイズ（starship.toml のシンボリックリンク作成）
- **zoxide** - cd の高速代替
- **fzf** - ファジーファインダー（Git からクローン）
- **ripgrep** - grep の高速代替
- **uv** - 高速 Python パッケージインストーラー
- **Node.js** のインストール（LTS 版）
- **Claude Code** - AI アシスタント CLI

## ターミナルのフォント選択

Hack Nerd Font を選択（Mac では Brewfile で自動インストールされます）

## Linux 固有の注意事項

### root/非root 対応
スクリプトは root ユーザーと非 root ユーザーの両方で実行可能です。
非 root の場合は自動的に `sudo` を使用します。

## CUDA のインストール（GPU 使用時のみ）

https://developer.nvidia.com/cuda-toolkit-archive
[Linux] - [x86_64] - [Ubuntu] - [20.04] - [runfile(local)] を選択した後指示に従う

```bash
wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda_11.3.0_465.19.01_linux.run
sudo sh cuda_11.3.0_465.19.01_linux.run
```

## cuDNN ダウンロード（GPU 使用時のみ）

[こちらのリンク](https://developer.nvidia.com/rdp/cudnn-download)から cuDNN をダウンロード

例：
[cuDNN v8.5.0 (August 8th, 2022), for CUDA 11.x Local Installer for Ubuntu20.04 x86_64 (Deb)](https://developer.nvidia.com/compute/cudnn/secure/8.5.0/local_installers/11.7/cudnn-local-repo-ubuntu2004-8.5.0.96_1.0-1_amd64.deb)

```bash
sudo dpkg -i cudnn-local-repo-ubuntu2004-8.5.0.96_1.0-1_amd64.deb
sudo apt install cudnn-local-repo-ubuntu2004-8.5.0.96
```

---

## トラブルシューティング

### pyenv が見つからない
シェルを再起動するか、以下を実行してください：

```bash
source ~/.profile
```

### poetry が見つからない（Linux）
以下のパスを確認してください：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### uv または claude が見つからない（Linux）
以下のパスを確認してください：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### tmux 設定が反映されない
tmux セッション内で以下を実行してください：

```bash
tmux source ~/.tmux.conf
```
