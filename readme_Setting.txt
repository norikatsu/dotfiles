//******************************************************************************
//
//  File Name : readme_Setting.txt
//  Type      : Text File
//  Function  : Dot files の管理方法の説明
//  Author    : Yoshida Norikatsu
//              2011/05/14 Start
//              2011/05/16 リポジトリ記載追加
//              2011/05/18 Gitでのローカル管理を行う
//              2011/05/23 gitignore で無視するファイルを設定
//              2011/05/25 vim git のインストールについての記載追加
//              2011/05/26 2.1 git参照URLの記述修正 (trunk)を削除
//              2011/05/29 Windows版のVIM関連の記述を追加
//              2011/06/03 ファイル名を "readme_Setting" に変更
//                           内容についても dotfiles 類のセッティング方法をとりまとめる
//
//******************************************************************************

1.概要
    ドットファイルは OSとして Linux, Cygwin, Mingwで共用とする。また家と会社でも共有する。
    全て、svnで管理する
    管理リポジトリは
        http://norikatsu.unfuddle.com/svn/norikatsu_dotfiles/trunk

    1.1 環境依存ファイルについて
        環境依存の切り分けは OSの違いを環境変数 $OSTYPE で切り分ける
        家と会社の環境の違いは個人的に定義した環境変数 $LOCATIONTYPE で切り分ける。
        この変数は 以下のファイルで設定する
            /etc/profile
        現時点では MYHOME と OFFICE の二種類

            1.家庭用の設定
                export LOCATIONTYPE=MYHOME

            2.会社用の設定
                export LOCATIONTYPE=OFFICE


2.ドットファイルについて
    管理しているファイルは　ドットファイル類と解説テキスト類になる。
    Linux用のファイル構成が基本となっているため、VIMの設定ファイルについては注意が必要（後述）
    会社専用の設定は特にプロキシ関連の設定が必要になる（後述）


    2.1 ダウンロード方法
        git-svnにて展開する。
            LinuxのGitインストール方法　→ "readme_installandhowto.txt"参照
            WindowsのGitインストール方法 → CygwinのGitを使用

        以下のコマンドを $HOMEで実行する
        $ git svn clone -s http://norikatsu.unfuddle.com/svn/norikatsu_dotfiles/


    2.2 VIM設定
        Windowsとそれ以外で参照するフォルダが異なるためWindowsでは専用設定が必要

            設定ファイル    これは共通
                Windows     .vimrc .gvimrc
                Cygwin      .vimrc .gvimrc
                Linux       .vimrc .gvimrc 

            設定フォルダ    Windowsのみ異なる
                Windows     vimfiles   <- これのみ .vim に対するジャンクションで実装
                Cygwin      .vim/
                Linux       .vim/


        2.2.1 ホームディレクトリを設定
            Windowsの環境変数 %HOME% にホームディレクトリを設定する


        2.2.1 ジャンクションの設定
            2.2.1.1 WindowsXPでの設定
                1. "Junction" をダウンロードし パスの通った場所にインストール
                2. $HOME に移動し DOSにて以下のコマンド実行
                    > junction .\vimfiles .\.vim


            2.2.1.2 Windows7での設定
                1. $HOME に移動し DOSにて以下のコマンドを実行
                    > mklink /j .\vimfiles .\.vim

        2.2.2 VIM プラグイン展開
            vimのプラグイン vim/vundle.git は submodule管理している
            以下のコマンドを実行する
             $ git submodule init
             $ git submodule update



        2.2.3 vundle が使用する curl の設定
            自動ダウンロードに Curl を用いているためこの準備が必要

            2.2.3.1 Windowsの設定
                1."MsysGit" をインストールする
                2. 以下の内容のファイルを C:\Program Files\Git\cmd に作り、パスを通しておく
                    ------------------------------------------------------------------------------
                    @rem Do not use "echo off" to not affect any child calls.
                    @setlocal

                    @rem Get the abolute path to the parent directory, which is assumed to be the
                    @rem Git installation root.
                    @for /F "delims=" %%I in ("%~dp0..") do @set git_install_root=%%~fI
                    @set PATH=%git_install_root%\bin;%git_install_root%\mingw\bin;%PATH%

                    @if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
                    @if not exist "%HOME%" @set HOME=%USERPROFILE%

                    @curl.exe %*
                    -----------------------------------------------------------------------------

            2.2.3.2 Cygwinの設定
                cygwinのcurlはそのままではsslでエラーが発生するため以下を実行
                    $ cd /usr/ssl/certs
                    $ curl http://curl.haxx.se/ca/cacert.pem | awk 'split_after==1{n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "cert" n ".pem"}'
                    $ c_rehash


            2.2.3.3 CentOSの設定
                CentOS上でSSLエラーが発生する場合には以下のコマンドで curl の証明書を更新する
                    $ cp /etc/pki/tls/certs/ca-bundle.crt ~/     (これは現在設定のバックアップ)
                    $ sudo curl http://curl.haxx.se/ca/cacert.pem -o /etc/pki/tls/certs/ca-bundle.crt

        2.2.4 vundleによるプラグインインストール
            !!! 会社でプラグインインストールにはProxyの設定が必要 -> 2.4 に記載 !!!

            インストールしたいプラグインを .vimrc に記入
            VIM上で ":BundleInstall" と入力することで プラグインをインストールする
            詳細は "readme_installandhowto.txt" を参照


    2.3 プロキシ設定
        会社ではProxy設定が必要
        プロキシサーバ : proxy.mei.co.jp:8080

        基本的な http等のプロキシ設定は .bash_profile内で行われている
        Linuxでは .bash_profileで リンクを張ることでProxyを有効にするソフトもある（後述）

        2.3.1 yum の設定
            /etc/yum.confの[main]セクションにに下記の１行を追加。
                -----------------------------------------
                [main]
                 ・・・いろいろ省略・・・
                proxy=http://proxy.mei.co.jp:8080/
                -----------------------------------------

        2.3.2 wget の設定
            ~/.wgetrc に設定が記述されている
            会社のLinuxでは  ~/.wgetrc_office_linux に対するソフトリンクを .bash_profile内で作成する


        2.3.3 Gitの設定
            GitプロトコルでProxyを経由する為には corkscrew をインストールする必要がある
            1. corkscrewのインストール
                -> "readme_installandhowto.txt"を参照

            2. /usr/local/bin/git-proxy ファイルを作成
                以下のコードを記入し 実行権限を与える
                --------------------------------------------------------
                #!/bin/bash
                CORKSCREW=`which corkscrew`
                $CORKSCREW [ProxyServerAddress] [ProxyServerPort] $1 $2
                --------------------------------------------------------

            3. 以下の環境変数を設定 (.bash_profile内で行われている)
                export GIT_PROXY_COMMAND=/usr/local/bin/git-proxy


        2.3.4 Mercurialの設定
            ~/.hgrc に設定が記述されている
            会社のLinuxでは  ~/.hgrc_office_linux に対するソフトリンクを .bash_profile内で作成する


        2.3.5 pearの設定
            このコマンドはよくわからない ??
            pearコマンドで proxyサーバを指定する

            $ pear config-set http_proxy プロクシーサーバ名:ポート番号


        2.3.6 Subversion & TortoiseSVN 設定
            Tortoisesvn では Documento&Setting App 以下にある
                "subversion\servers"ファイルに以下の設定を行う

            SVNでは ~/.subversion/servers ファイルに以下の設定を行う
                -------------------------------------------------------
                [global]
                http-proxy-exceptions = localhost,133.181.137.151
                http-proxy-host = proxy.mei.co.jp
                http-proxy-port = 8080
                -------------------------------------------------------

3.X-server について
    Windows側からLinuxへ X経由で接続するための設定
    サーバは cygwin版、Xming版二種類あるが、Xming版を用いる

    3.1 Linux側の設定
        XDMCP の設定

        3.1.1 SELinux 設定は Permissive または Disabled とする

        3.1.2 /etc/gdm/custom.conf の編集
            ---------------------------------
            [securiry]
            AllowRemoteRoot=true
            [xdmcp]
            Enable=true
            ---------------------------------

        3.1.3 /etc/hosts.allow と /etc/hosts.deny の設定
            /etc/hosts.allow にはアクセスを許可するホストを記述
            /etc/hosts.deny にはアクセスを拒否するホストを記述
            hosts.allowが優先される

            例えば、 Linuxホスト側で、GNOME環境のgdmが動作していて (＝XDMCP接続を行う)
            IPアドレスが 192.168.100.* の範囲にあるホストからのアクセスを許可する 場合には
            /etc/hosts.allow を以下のように設定

            --------------------------------
            all: 127.0.0.1
            gdm: 192.168.100.
            --------------------------------

            127.0.0.1 は自分自身へのアクセスを意味している
            デーモン名については必要に応じて、XDMCP の場合は、 gdm、 kdm、 xdm、 など、 rexec の場合は in.rexecd と記述します。

            以下に実際の設定
            /etc/hosts.allow
            all : 127.0.0.1 10.64.221.16

            /etc/hosts.deny
            gdm:ALL

        3.1.4 Xフォントサーバの設定  /etc/X11/fs/config

            修正前             修正後（コメントアウト）
            no-listen = tcp    #no-listen = tcp;


        3.1.5 ファイアウォールの設定

            XDMCP(xdmcp:udp) と Xフォントサーバ(xfs:tcp) のために、ファイアウォールに穴を空ける

            メニューバーから「デスクトップ」→「管理」→「セキュリティレベルとファイヤーウォールの設定」を選択。
            [セキュリティレベル] 画面が表示されて、[ファイアウォールのオプション] タブが選択されている。
            [その他のポート] をクリックすると、ポートの追加領域が表示される。
            [追加] ボタンをクリックして、“xdmcp udp” と “xfs tcp” を登録。
            [OK] ボタンをクリック。



    3.2 Windows側の設定
        3.2.1 シングルウィンドウ
            1.Cygwinによる設定を例として記述する
                "C:\cygwin\bin\XWin.exe -fullscreen -depth 32 -query LinuxPCのIP -from WindowsPCのIP"

                "C:\cygwin\bin\XWin.exe -screen 0 1280 800 -query LinuxPCのIP -from WindowsPCのIP"
                                        ^^^^^^^^^^^^^^^^^^

                "1280 800" が XWinのウィンドウサイズになります。例では 1280x800 のウィンドウが表示される。



        3.2.2 マルチウィンドウ
            1.Xming - XLaunch を実行
                1.Multiple window
                 （number：適当な数字　複数の設定を行う場合は異なる数字を用いる）
                2.start a program
                3.Start program 
                    $HOME/start_at_xming.sh を指定
                4.Using PuTTy -> Connect to Computer等の設定は接続先の IP user passを入力
              上記設定を config.xlaunch で保存

            2. $HOME/start_at_xming.sh を作成
                -> このファイルはすでに リポジトリに登録済み


4.Samba 設定
    ここに記すSambaの設定は CentOS の例である
    4.1 インストール
        アプリケーション　-　ソフトウェアの追加と削除をクリック
        「パッケージマネージャ」が起動するので、サーバ - Windowsファイルサーバ にチェックを入れ、適応ボタンをクリック

    4.2 設定
        システム - 管理 - サーバ設定 - samba をクリック
        4.2.1 ユーザ登録
            プレファレンス-sambaのユーザをクリック
            ユーザーの追加をクリック
            unixユーザー名から 既存の自分のアカウントを選択
            winsowsユーザー名:上と同じにしておく
            sambaのパスワード：上記のアカウントと同じパスワードにしておく

        4.2.2 共有したいフォルダ (自分のホームなど)追加
             ディレクトリ：共有フォルダ
             共有名：Windowsから見えるフォルダ名
             記述  :適当な説明
             アクセス ：アクセス制限 → 特定のユーザーのみのアクセス許可を選び 先ほど作成したユーザーを選択

        4.2.3 設定ファイルの修正
             /etc/samba/smb.conf を編集
            80行目付近の "hosts allow"のコメントアウトを解除し以下(???? 部は自分のマシンのIP)のように修正
            hosts allow = 127.  10.64.221.????

            235行目付近の "map archive"のコメントアウトを解除し以下のように修正
            map archive = no

    4.3 サービス起動
        システム - 管理 - サーバ設定 - サービスをクリック
        バックグラウンドのサービス内から "smb"にチェックを入れ、保存をクリック（これで次回起動時からサービス開始）

    4.4 ファイアウォール設定
        システム - 管理 - セキュリティレベルとファイヤーウォールの設定 をクリック

        ファイアウォールのオプションタブを選択し Sambaにチェックマークを入れ　適応をクリック



5.プリンタ設定 (for Linux)
    ここに記すプリンタの設定は CentoOSの例である

    5.1 Canonの例
        5.1.1 
            linux用のドライバ 以下の2つをダウンロード 
            "CUPSドライバ共通モジュール"
            "LIPSLX Printer Driver"

        5.1.2
            上記2つをインストール（先に CUPSをインストール）

        5.1.3
            設定-印刷　から プリンタの追加
            たいていは任意でよい　
            「接続の種類」は "AppSocket/HP jetDirect"を選択
            ホスト名には プリンタのIPアドレスを入力　ポートは9100のまま
            デバイス選択で先ほどインストールしたドライバが有効になっていれば LBP3900/3950 が選べるようになっている

    5.2 EPSONの例
        LP9800のドライバは既にインストールされているので、直接プリンタの追加を行えばOK



X.管理ファイル一覧
  → .gitignore で管理しているので 新規追加、削除があった場合には編集すること

