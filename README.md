# dotfiles

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
