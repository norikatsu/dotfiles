//******************************************************************************
//
//  File Name : readme_InstallandHowto.txt
//  Type      : Text File
//  Function  : Linux Cygwin 環境のソフトのインストール方法と簡単な使い方説明
//  Author    : Yoshida Norikatsu
//              2011/06/04 Start
//              2011/06/19 rpmforgeのバージョンなど修正
//              2011/06/20 VIM のリンク記述追加修正
//              2012/07/06 Xwindow あんちょこ追加
//
//******************************************************************************

1.概要
    Linux環境は CentOS 5 64bit をメインに想定。
    会社の環境ではProxyの設定が必要なので readme_setting.txtを参照すること


2.rpmforge リポジトリの追加 (for CentOS)
    2.1 sudo 設定
        $ su -
        # visudo
            -> "user   ALL=(ALL) ALL" を追加する　userは権限を与えたいユーザ名

    2.1 ファイルの取得
        $ cd /usr/local/src
        $ sudo wget http://dag.wieers.com/packages/rpmforge-release/rpmforge-release-?????.rpm
        $ sudo wget http://dag.wieers.com/packages/RPM-GPG-KEY.dag.txt

    2.2 rpmパッケージのインストール
        $ sudo rpm -ivh rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm

    2.3 enabledに0を設定。
        yumコマンドで今追加したリポジトリを常時参照するのではなく必要な時だけ使うための設定。
        $ sudo vim /etc/yum.repos.d/rpmforge.repo

            -----------------------
            #enabled = 1
            enabled = 0
            -----------------------


3.アプリインストール方法
    3.1 Git インストール方法
        3.1.1
            以下のコマンドでインストール
            $ sudo yum -y --enablerepo=rpmforge install git git-svn

        3.1.2
            プロキシ設定については "3.7 corkscrewインストール" を参照すること
              次いで、"readme_setting.txt" を参照

    3.2 Mercurial インストール方法
        VIM 等は Mercurialで管理されているので、このインストールが必要
        3.2.1
            以下のコマンドでインストール
            $ sudo yum -y --enablerepo=rpmforge install mercurial

        3.2.2
            プロキシ設定は ~/.hgrc で行う。
            Office のLinuxでのみ有効にする為 ~/.hgrc_office_linux に対して ~/.bash_profile でリンクを張る


    3.3 VIM インストール方法
        事前に Mercurialをインストールしておくこと
        3.3.1 インストール
            1.以下のコマンドでインストール
                $ hg clone https://vim.googlecode.com/hg/ vim

            2.ダウンロードした vimディレクトリに移動し configure 実行
                $ ./configure --enable-multibyte --enable-xim --enable-fontset --disable-selinux --with-features=huge --prefix='/usr/local/vim-7.4' --enable-luainterp=yes

                ( redhat環境では with-lua-prefixはデフォルトのままでいいので指定せず ubuntu等は別途指定が必要
                   $ ./configure --enable-multibyte --enable-xim --enable-fontset --disable-selinux --with-features=huge --prefix='/usr/local/vim-7.4' --enable-luainterp=yes --with-lua-prefix=/usr/local などといった感じ・・・・)

            3. make 実行
                $ make

            4.既存のvimをアンインストール
                $ sudo yum remove vim-enhanced

            5. インストール
                $ sudo make install

            6. 元インストール先のvimパス(/usr/bin/vim) にリンクを張る(実態は全て vimでよい)
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/vim
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/gvim
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/view
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/eview
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/evim
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/ex
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/gview
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/gvimdiff
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/rgview
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/rgvim
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/rview
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/rvim
                $ sudo ln -s /usr/local/vim-7.4/bin/vim /usr/local/bin/vimdiff

            7. /usr/bin/vi の無効化
                bashrc でエイリアス指定
                alias vi='vim'

                SVNのEDITOR にvimを指定

                export SVN_EDITOR=vim
                export EDITOR=vim


        3.3.2 プラグインコントロール
            プラグインのインストールは "Vundle" で行う。内部で Git を使用する場合があるため
            会社の環境では、GitのProxy 設定が必要 -> "readme_setting.txt"を参照する


        3.3.3 日本語IMEの設定
            Linux環境でノーマルモード時に日本語モードをOFFにする設定を行う
            処理には "xvkbd"を用いる
            1. SCIMのキーバインド設定
                SCIM OFF に <SHIFT>+<CTRL>+<SPCACE>  を設定
            2. xvkbd のインストール
                $ wget http://homepage3.nifty.com/tsato/xvkbd/xvkbd-3.2.tar.gz 

                解凍フォルダ内で以下実行
                $ xmkmf
                $ make
                $ sudo make install

    3.4 m4 インストール
        SCREENのインストールに最新版が必要となる
        3.4.1
            1. wgetで rpmソースを入手しビルドする (会社の環境ではProxyの設定が必要）
                $ wget ftp://ftp.riken.go.jp/Linux/fedora/releases/11/Fedora/source/SRPMS/m4-1.4.12-2.fc11.src.rpm
                $ sudo mkdir -p /usr/src/rehdat/SOURCES
                $ sudo rpm -ivh --nomd5 m4-1.4.12-2.fc11.src.rpm
                $ cd /usr/src/redhat/SPECS
                $ sudo yum install rpm-build
                $ sudo rpmbuild -ba m4.spec
                $ cd ../RPMS/i386
                $ sudo rpm -Uvh m4-1.4.12-2.XXXXXX.rpm   <- (32bitでは i386、64bitでは x86_64)

            X.ソースコードからのインストール（通常は不要）
                $ wget ftp://ftp.gnu.org/gnu/m4/m4-1.4.10.tar.gz
                $ tar zxvf m4-1.4.10.tar.gz
                $ cd m4-1.4.10
                $ ./configure --prefix=/usr/local/
                $ make
                $ make install


    3.5 autoconf インストール
        SCREENのインストールに バージョン2.6* 必要となる
        autoconf 2.6*のビルドには m4が必要なので事前にインストールすること
        3.5.1
            1. wgetで rpmソースを入手しビルドする (会社の環境ではProxyの設定が必要)
                $ wget ftp://ftp.riken.go.jp/Linux/fedora/releases/11/Fedora/source/SRPMS/autoconf-2.63-2.fc11.src.rpm
                $ sudo rpm -ivh --nomd5 autoconf-2.63-2.fc11.src.rpm
                $ cd /usr/src/redhat/SPECS
                $ sudo rpmbuild -ba autoconf.spec
                $ cd ../RPMS/noarch
                $ sudo rpm -Uvh autoconf-2.63-2.noarch.rpm


    3.6 screen インストール
        SCREEN のインストール時には emacs,autoconfが必要なので事前にインストールすること
        3.6.1
            1. emacs インストール (yumでOK)
            2. m4 インストール (3.4参照)
            3. autoconf インストール (3.5参照)

            4. screenビルド
                $ git clone git://git.savannah.gnu.org/screen.git
                $ cd screen/src
                $ autoconf
                $ autoheader
                $ ./configure --prefix=/usr/local --enable-colors256
                $ make && sudo make install
                $sudo cp ./etc/etcscreenrc /usr/local/etc/

        3.6.2 Cygwin版の補足事項
            デタッチ、アタッチを使うために 環境変数 CYGWIN に ttyを設定すること
            cygtermでは
            cygterm.cfg に以下の記述をする事
                ---------------------------------------
                ENV_2  = CYGWIN="tty codepage:utf8"
                ---------------------------------------


    3.7 corkscrewインストール
        Gitのproxy設定に必要なアプリケーション
        3.7.1 インストール
            ソースをダウンロードして、ビルド 
            # wget http://www.agroman.net/corkscrew/corkscrew-2.0.tar.gz
            # tar zxvf corkscrew-*.*.tar.gz
            # cd corkscrew-*.*
            # ./configure
            # make
            # sudo make install
i
        3.7.2 Proxy用のスクリプト作成
            /usr/local/bin/git-proxy を作成

            ------------------------------------------------------
            #!/bin/bash
            CORKSCREW=`which corkscrew`
            $CORKSCREW [ProxyServerAddress] [ProxyServerPort] $1 $2
            ------------------------------------------------------
                ※プロキシサーバ等は以下のように設定する

                $CORKSCREW proxy.mei.co.jp 8080 $1 $2

            作成ファイルに実行権限を与える

            # sudo chmod 755 /usr/local/bin/git-proxy


        3.7.3 bash_profile編集 (すでに記入済み)

            # git-proxy
            export GIT_PROXY_COMMAND=/usr/local/bin/git-proxy



    3.8 Subversionのインストール
        Windows の TortoiseSVNとLinuxのコマンドライン版のバージョンをそろえる目的で
        1.6系をLinuxにインストールする

        3.8.1 インストール
            http://www.collab.net/downloads/subversion/ より CollabNet版のSubversionをダウンロードする

            CollabNetSubversion-client-1.6.16-1.x86_64.rpm を手動でインストール

        3.8.2 svn へのリンク作成
            古い svn /usr/bin/svn を 削除 or リネームし
            /opt/CollabNet_Subversion/bin/svn に対する リンクを /usr/bin/svn に貼る

                # sudo mv /usr/bin/svn /usr/bin/svn_ver1.4.2
                # sudo ln -fs /opt/CollabNet_Subversion/bin/svn /usr/bin/svn


        3.8.3 Windows側 TortoiseSVN のバージョンをそろえる

            TortoiseSVN-1.6.15.21042-win32-svn-1.6.16 をインストール


    3.9 Dropboxのインストール
        CentOSでは オフィシャルパッケージが無いため rpmforge版を用いる

        3.9.1 インストール
            $ sudo yum install dropbox --enablerepo=rpmforge

        3.9.2 初期設定
            $ dropbox

        3.9.3 サービスでユーザを有効にする 
            # sudo vi /etc/sysconfig/dropbox

            下記行を追加 DROPBOX_USERSには利用するユーザをスペース区切りで記述
            DROPBOX_USERS=nori

        3.9.4 サービスを開始
            管理-サービスで dropboxが起動するように設定する
            -> 3.9.3 で設定したユーザ（アカウント）でDropboxがサービスを開始しているか確認


    3.10 QuartusII for Linux のインストール方法
        この文章は 「開発G版」についての記述である
        中身はオリジナルと一緒 インストーラ無しでパッチ済み

        3.10.1 インストーラ の場所
            : \\fs-kita3.japan.gds.panasonic.com\sav2$\eda\lsi-wg\archive\alt

            上記統合ファイルサーバの場所を mnt する

        3.10.2 インストール方法
            $ mkdir /usr/local/altera
            $ cd /usr/local/altera
            $ tar zxvf /mnt/sav2/*****/quartus-100_sp1.tgz
            $ mkdir /usr/cad
            $ ln -s /usr/local/altera/quartus-100/ /usr/cad/quartus-100

        3.10.3 環境変数の設定
            ライセンスサーバ、QUARTUS_ROOTDIR 、PATHの3つの設定を行う
            この設定は ~/.bash_profile 内にで記述してある

            ex.
            ----------------------------------------------------
            export LM_LICENSE_FILE=1700@133.181.137.195
            export QUARTUS_ROOTDIR=/usr/cad/quartus-100/quartus
            export PATH=$PATH:$QUARTUS_ROOTDIR/bin
            ----------------------------------------------------



    3.11 Quest (Modelsim) for Linux のインストール方法

        3.11.1 インストーラ の場所
            : \\fs-kita3.japan.gds.panasonic.com\sav2$\eda\lsi-wg\archive\mentor\questa\questa-66c.tgz

        3.11.2 インストール方法
            $ mkdir /usr/local/menter
            $ cd /usr/local/menter
            $ tar zxvf /mnt/sav2/*****/questa-66c.tgz
            $ mkdir /usr/cad （QuartusIIインストール時に作っていたら不要）
            $ ln -s /usr/local/menter/questa-66c /usr/cad/questa-66c

        3.11.3 環境変数の設定
            ライセンスサーバ、MODEL_TECH 、PATHの3つの設定を行う
            この設定は ~/.bash_profile 内にで記述してある

            ex.
            ----------------------------------------------------
            export LM_LICENSE_FILE=1717:@132.182.83.174 (追加するように記述すること)
            export MODEL_TECH/usr/cad/questa-66c/questasim
            export PATH=$PATH:$MODEL_TECH/bin
            ----------------------------------------------------

        3.11.4 FPGAライブラリ設定
            LinuxでQuesta(Modelsim)を使用するときに必要な Altera用ライブラリのインストール方法
            （単純にAltera版の Modelsimをインストールします）

            アーカイブを下記フォルダにアップ済み
                \\fs-kita3.japan.gds.panasonic.com\sav1$\tech\devcam\【永久保管】COMMON\C-技術資料、シンポジューム\C-FPGA技術資料\Altera\QuartusIIインストールプログラム\QuartusII10.0SP1Linux(Modelsimのみ)


            Altera版ModelSimインストール
               $ sudo chmod a+x 10.0sp1_modelsim_ase_linux.sh
               $ sudo 10.0sp1_modelsim_ase_linux.sh 
                    Destinaton Directory:インストール先は以下のようにしました
                        /usr/local/altera/modelsim_ase-100sp1

               $ sudo chmod -R 777 /usr/local/altera/modelsim_ase-100sp1/modelsim_ase/altera
                   (Questaは参照ライブラリに対する書き込み属性が必要なのでパーミッション変更)

        3.11.5 GCC へのリンクを作成
            MODEL_TECH 下にGCCへのリンクは作成（rebuildから呼び出されるMakefileが参照するため）
                $ sudo mkdir ${MODEL_TECH}/gcc-4.0.2-linux
                $ sudo mkdir ${MODEL_TECH}/gcc-4.0.2-linux/bin
                $ sudo ln -s /usr/bin/gcc ${MODEL_TECH}/gcc-4.0.2-linux/bin/gcc


    3.12 RapidSVN, Meld, Genyのインストール
        GUIでのSVN EDITER DIFFツールのインストール、設定方法を記述する

        3.12.1 インストール方法
            rpmforge をリポジトリに指定し、yumでインストールする
            パッケージは
                rapidsvn-*****
                geany
                meld

        3.12.2 RapidSVN の環境設定
            RapidSVNを実行
                View - Preferences の Programsタブを選択し下記のプログラムを登録

                1.Standard Editor   Program（上段空欄）"/usr/bin/geany"
                                    Program arguments  "%1"

                2.Standard Explorer Program（上段空欄）"/usr/bin/nautilus"
                                    Program arguments  "%1"

                3.Diff Tool         Program（上段空欄）"/usr/bin/meld"
                                    Program arguments  "%1 %2"

                4.Merge Tool        Program（上段空欄）"/usr/bin/meld"
                                    Program arguments  "%2 %4 %3"


    3.13 VMware Playerのインストール(for Windows)
        通常にインストールするだけ
        しかし ネットワーク設定用の vmnetcfg.exe がそのままではインストールされない
        インストーラから抽出する必要がある

             C:\>VMware-player-3.0.0-203739.exe /e .\extract

        これにより、extract というディレクトリができ、その下に network.cab がある
        これを展開すると vmnetcfg.exe が取り出せる。
        このファイルをVMWare Player3.0がインストールされているディレクトリにコピー
        (他のディレクトリだと、dllのエラーがでて動かない)


    3.14 WOL のインストール
        1. BIOSで電源管理部の "S5状態から起動" と "ブートのネットワークブート" 以上2カ所を有効にしておく
        2. Windows アプリケーション "wol"をインストール
        3. ブートしたいPCの MACアドレス、マシン名を登録
        4. Windowsでショートカットを作成
            "C:\Program Files\wol\wol.exe" -wake nori-linux    <- ここで nori-linux がブートしたいPCの名前

        作成したショートカットダブルクリックで起動する

    3.15 VirtualBoxのインストール(for Windows)
        1. Virtualbox上にゲストOSとしてLinuxをインストールする
        2. "gcc" "kernel-devel" パッケージをインストール
        3. Virtualbox上で"GuestAdditions"のメニュー選択
        4. Linux上で以下のコマンド実行
            $ sudo sh /media/VBOXADDITIONX_****/VBoxLinuxAdditions.run


4. アプリ使い方
    4.1 Gitの使い方
        4.1.1 Git簡単な構成の説明
            ワーキングツリー(作業中のファイル)
            インデックス(ステージング)
            コミットツリー(HEAD)  (.git フォルダ内に全て記録される)

        4.1.2 コマンド
            $ git init          ローカルリポジトリ作成
            $ git clone URL     既存リポジトリからクローン
                -sオプションは trunk/ branches/ tags/ などがある場合に、 trunk をmasterに割り当ててくれる
            $ git commmit   インデックスをコミット

            $ git reset         元に戻す （使うときには注意！)
                $ git reset HEAD            インデックスを戻す (addの取り消し)
                $ git reset --hard HEAD     インデックスもワーキングも戻す

                $ git reset HEAD^           コミットを一つ前に戻す
                $ git reset HEAD^^          コミットを二つ前に戻す

                $ git revert (コミットハッシュ) 特定のコミットだけ取り消す

                リポジトリの取り消し（複数コミットを取り消すとき）
                    $ git revert -nオプションを使う  (巻き戻す変更をいったんステージングにのせて、コミットはしないでおくオプション)

                    $ git revert -n (コミットハッシュ)
                    $ git revert -n (コミットハッシュ)
                    $ git revert -n (コミットハッシュ)
                    $ git commit

            $ git push          ローカルからリモートリポジトリへ
            $ git svn dcommit   ローカルからリモートリポジトリへ (git svn)


            $ git checkout -b mywork  (これは myworkブランチを作ってcheckoutしている)
                このブランチが不要なら 削除
                $ git checkout master
                $ git branch -D mywork


            ブランチを採用するならマージ(コミットは個別のまま)
            $ git checkout master
            $ git merge mywork  →(  --squash を追加するとコミットは1つにまとまる)
            $ git svn dcommit
            $ git branch -d mywork


            コミットをまとめる その1
            $ git rebase -i HEAD~3  (直近三回のコミットを対象にする)
                    以下のような表示がでるので、まとめる対象を pick-> squash に書き換える
                    （先頭の一つは pickのままにすること！)   → するとまとめのコメント入力画面になる
                    ---------------------------
                    pick 0000000 fixed a bug
                    pick 1111111 edited POD
                    pick 2222222 changed Feature

            コミットをまとめる方法 その2
            別ブランチにマージするときにまとめてしまう
            $ git merge --squash BRANCH
                → これは インデックス 状態になって反映されるのでこの後コミットすること！


        4.1.X Cygwinでの不具合対応
            内部で読んでいるdllで不具合が生じる場合がある。その場合は以下のコマンドを実行
            DOS窓で以下のコマンドを実行
               > C:\cygwin\bin\ash
               $ /bin/rebaseall -v


    4.2 VIMの使い方
        4.2.1 プラグインを Vundleで管理している
            インストール
            アップデート
            アンインストール

        4.2.2 コンパイルセッティング
            自分で Verilog用を作成している

        4.2.3 スニペット補完
            Neoconpleを使用している
            スニペットファイルは ~/.vim/snippets/以下に作成している
            コマンドの説明



    4.3 Linuxコマンドの使い方
        4.3.1 mount
            4.3.1.1 直接マウント
                $ mount /マウント元 /マウント先

                Windows共有のマウント
                $ mount //WindowsPCのIPアドレス/共有ディレクトリ /mnt/tmp -o  user=winuser,password=winpassword

            4.3.1.2 fstabの記述
                IPアドレスは統合ファイルサーバのアドレス
                /mnt/tmpは任意の場所
                ID パスワードは統合ファイルサーバのもの

                //10.69.84.141/sav1$    /mnt/tmp    cifs   user=統合ファイルサーバのID,password=統合ファイルサーバのパスワード,file_mode=0777 dir_mode=0777 0 0


        4.3.2 link

            $ ln -s リンク元 リンク先

            ex. サンプル
            $ ln -s /mnt/tmp/ /home/user/work
            これで /mnt/tmpディレクトリが /home/user/workとしてアクセス出来る

        4.3.3 sudo
            有効にするため root になって 下記コマンド実行
            # visudo

            viが起動するので、以下の設定を記入する

            ----------------------------------------------------
            ## Allows people in group wheel to run all commands
            username ALL=(ALL) ALL     
            ----------------------------------------------------

            username はsudoの権限を与えるユーザ  これでusenameは全てのroot権限を持つことになる
 

    4.5 文字コード変換方法
        nkfを使って複数ファイルを一括変換する方法

            $ find . -name "*.php" | xargs nkf -s --overwrite 　（サブディレクトリ以下を shiftjis に一括変換)
                (.php は任意の拡張子)

            nkf オプション
                j(省略可能) : JISコード(ISO-2022-JP)を出力
                e : EUCコードを出力
                s : Shift-JISコードを出力
                w : UTF-8コードを出力（BOM無し）
                Lu : unix改行形式(LF)に変換
                Lw : windows改行形式(CRLF)に変換
                Lm : macintosh改行形式(CR)に変換
                g(--guess) : 自動判別の結果を表示
                overwrite : 引数のファイルに直接上書き
                version : バージョン情報を表示(インストール済チェック)

5. その他
    5.1 Xwindow あんちょこ
        sshで リモート端末にログインし、そこから Windows上の Xmingに飛ばしたい場合の設定
        1. Xming の設定
            Xming インストールディレクトリにある "X0.hosts"ファイルに sshでログインする リモートPC
            の IPアドレスを追記

        2. リモート端末の設定
            sshでログインした端末内で DISPLAY変数に WindowsのIPアドレスと ウィンド番号を設定
                ex. export DISPLAY=10.64.221.255:0.0

        3. Windows側で Xming 起動

        以上で リモート側から xterm等を起動すると Windows上にウィンドウを飛ばせる



    5.2 Subverson あんちょこ
        ブランチ、タグ等コピーのしかた
          $ svn copy -r [リビジョン番号] [作成元のURL] [タグまたはブランチのURL]
