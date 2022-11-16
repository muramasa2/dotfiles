# dotfiles

# Mac での環境構築

## Xcode のインストール

[URL](https://itunes.apple.com/jp/app/xcode/id497799835?ls=1&mt=12)

## VSCode インストール

[URL](https://code.visualstudio.com/download)

### code コマンドの PATH への追加

VSCode でコマンドパレットを開く（⇧⌘P）
表示されたコマンドパレットに shell command と入力。
インストールとアンインストールのオプションが表示された。

「シェルコマンド:PATH 内に'code'コマンドをインストールします」を選択。

### VSCode 拡張機能インストール

以下をインストール

- Pylance
- Remote - SSH
- Pylance

## 必要 python パッケージインストール

以下を実行

```
python -m pip install --upgrade pip
python -m pip install -U black
python -m pip install -U flake8
```

## 実行方法

```
> cd dotfiles
> ./install.sh
```

## ターミナルのフォント選択

Hack Nerd Font を選択

# Ubuntu での環境構築

## cuda のインストール

https://developer.nvidia.com/cuda-toolkit-archive  
[Linux] - [x86_64] - [Ubuntu] - [20.04] - [runfile(local)] を選択した後指示に従う

```
wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda_11.3.0_465.19.01_linux.run
sudo sh cuda_11.3.0_465.19.01_linux.run
```

## cuDNN ダウンロード

[こちらのリンク](https://developer.nvidia.com/rdp/cudnn-download)から cuDNN をダウンロード  
ex)

[cuDNN v8.5.0 (August 8th, 2022), for CUDA 11.x Local Installer for Ubuntu20.04 x86_64 (Deb)](https://developer.nvidia.com/compute/cudnn/secure/8.5.0/local_installers/11.7/cudnn-local-repo-ubuntu2004-8.5.0.96_1.0-1_amd64.deb)

```
sudo dpkg -i cudnn-local-repo-ubuntu2004-8.5.0.96_1.0-1_amd64.deb # sudo dpkg -i $(ダウンロードした deb ファイル path)
sudo apt install cudnn-local-repo-ubuntu2004-8.5.0.96
```

## 実行方法

```
> cd dotfiles
> ./install.sh
```
