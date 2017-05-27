# Windows10 環境のLinux,git,Ubuntu環境のインストール方法説明
---

## 概要
Win側のLinux環境として git for Windowsの bash環境をそのまま使用
Vivado, Quartusのインストール
日本語環境、vim環境を整備する
---

### 2. ===== 環境変数 HOME設定
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


### 3. ===== gvim起動
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



### 5. ===== gnome-terminal インストール

#### --- Ubuntu側の設定 

    sudo apt-get install aptitude
    sudo aptitude install gnome-terminal


#### --- 日本語入力ができるよう インストール
    sudo apt install fonts-ipafont
    sudo apt install uim uim-xim uim-anthy


#### --- 日環境変数設定
    export DISPLAY=localhost:0.0
    export XMODIFIERS="@im=uim"
    export GTK_IM_MODULE=uim 
    export QT_IM_MODULE=uim


で書いたかな漢字変換サーバとlxterminalの起動を自動化するなら、例えばhome directoryの.bashrcの末尾に
if [ $SHLVL -eq 1 ]; then
  if DISPLAY=localhost:0.0 xset q > /dev/null 2>&1 ; then
    DISPLAY=localhost:0.0 UIM_CANDWIN_PROG=uim-candwin-gtk uim-xim &
    DISPLAY=localhost:0.0 XMODIFIERS="@im=uim" GTK_IM_MODULE=uim QT_IM_MODULE=uim lxterminal &
  fi
fi
のように書けばいいでしょう。最初に起動されたbashで、なおかつXが利用可能なら、かな漢字変換サーバとlxterminalを起動します。


