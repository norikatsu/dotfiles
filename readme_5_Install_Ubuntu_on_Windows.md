# Windows10 環境のLinux,git,Ubuntu環境のインストール方法説明
---

## 概要
Win側のLinux環境として git for Windowsの bash環境をそのまま使用
Vivado, Quartusのインストール
日本語環境、vim環境を整備する
---

### 0. ===== 環境変数 HOME設定
    bash,vim等で参照するため
    HOME 変数に "C:\Users\?????"
    を設定する


### 1. ===== Git for Windows インストール  
    "https://git-for-windows.github.io/" よりダウンロードしたインストーラを使用
    インストールパスは特に指定は無いが
    "ProgramFiles"下にインストールしておくと 内部ファイルの書き換え制限が緩和される
    （デフォルトだとOSによる制限が加わるため管理者権限必要)

    インストール先の Git\etc\profile を編集
    LOCATIONTYPE=MYHOME 
         or 
    LOCATIONTYPE=OFFICE
    を設定する

### 2. ===== dotfile ダウンロード
    ホームディレクトリで
    $ git clone https://github.com/norikatsu/dotfiles.git 
    
    会社環境ではプロキシ設定が必要（下記設定は下の gitconfigリンク作成時に消すこと)

    $git config --global http.proxy http://proxy.mei.co.jp:8080
    $git config --global https.proxy http://proxmei.co.jp:8080

    ダウンロードしたらリンク作成
    管理者権限でコンソール起動後
    > mklink .bash_profile .\dotfiles\.bash_profile
    > mklink .bashrc       .\dotfiles\.bashrc
    > del    .gitconfig 
    > mklink .gitconfig    .\dotfiles\.gitconfig_****
    > mklink .gitingnore   .\dotfiles\.gitingnore
    > mklink .gvimrc       .\dotfiles\.gvimrc
    > mklink .inputrc      .\dotfiles\.inputrc
    > mklink .profile      .\dotfiles\.profile
    > mklink .vimrc        .\dotfiles\.vimrc
    > mklink /D .vim       .\dotfiles\.vim


### 3. ===== vim
    c:\ProgramFiles\vim に
    解凍
    同じディレクトリに ctags.exe も入れる

    初回起動時にプラグインのインストールが行われるので
    しばらくほっておく
    インストール後  .vimrc にあるように vimpron用のdllをコピーする


### 4. ===== cmderインストール
    ターミナルソフト(git bash , Ubuntu on bash用)
    mini版をインストール

    新しいtask を + でくわえる
    名前は {Git::bash}とでもしておく（任意）

    パラメータ（アイコン設定）は下記
    /icon "%CMDER_ROOT%\icons\cmder_blue.ico"
    実行コマンドは下記の様にする ????はインストールパス
    cmd /c ""C:\?????\Git\bin\bash.exe" --login -i" -new_console:d:%USERPROFILE%


    Ubuntu用は名前は {bash::Ubuntu}とでもしておく
    パラメータ（アイコン設定）は下記
    /icon "%CMDER_ROOT%\icons\cmder_red.ico"
    実行コマンドは以下のようにする
    "C:\Windows\System32\bash.exe ~"


### 5. ===== x-Finder
    
    c:\ProgramFiles\Xfinder に X-Finderをコピー
    その他、ツールとして
        Leeya
        E-rename
    をコピーする

    スタートアップに xf64.exe を登録

### 6. ===== SVN, WinMerge, VLC, IfranView
    それぞれ、最新版をダウンロードし
    インストーラでデフォルトパスにインストール

### 7. ===== リモートデスクトップ環境
    リモートデスクトップ接続時に、キーボード配置がUSに成っている場合、

    リモートで接続した状態で、
        デバイスマネージャー -> キーボード - リモートデスクトップキーボードデバイス を右クリック
        ドライバソフトウエアの更新
        コンピュータを参照してドライバソフトウエアの更新
        コンピュータ上のデバイスドライバーの一覧から選択
        互換性のあるハードウェアのチェックを外し、（標準キーボード）から"日本語PS/2キーボード(106/109) を選択
        再起動後有効化


### 8. ===== gnome-terminal インストール

#### --- Ubuntu apt リポジトリ変更 とアップデート
    sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list
    sudo apt update
    sudo apt upgrade

#### --- Ubuntu側の設定 

    sudo apt-get install aptitude
    sudo aptitude install gnome-terminal

    git のデフォルトエディタがvimではないので変更
    sudo update-alternatives --config editor



#### --- 日本語入力ができるよう インストール
    sudo apt install fonts-ipafont
    sudo apt install uim uim-xim uim-anthy


#### --- 日環境変数設定
    export DISPLAY=localhost:0.0
    export XMODIFIERS="@im=uim"
    export GTK_IM_MODULE=uim 
    export QT_IM_MODULE=uim


    上記設定を行うスクリプトを作成する
    if [ $SHLVL -eq 2 ]; then
        DISPLAY=localhost:0.0 UIM_CANDWIN_PROG=uim-candwin-gtk uim-xim &
        DISPLAY=localhost:0.0 XMODIFIERS="@im=uim" GTK_IM_MODULE=uim QT_IM_MODULE=uim gnome-terminal &
    fi


