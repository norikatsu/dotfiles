1. ProgramFilesのコピー
    1.1 vim, 7zip ConEmu は32bit、64bitで異なるので注意
    1.2 TortusSVN, WinMerge, VLC のインストール（64,32とも デフォルトの"Program Files"にインストール



2. MinGWのインストール

    2.1 MinGw環境を C:\MinGW にインストール
        msys 環境作り


    2.2 Git for Windows を C:\MinGW\Git にインストール
        文字コードはそのままを選択

    2.3 下記空フォルダを作成
        "C:\MinGW\msys\1.0\mingw\" 

    2.4 C:\MinGW\msys\1.0\etc\fstab を用意下記設定
        c:/MinGW        /mingw

    2.5 C:\MinGW\msys\1.0\etc\profile に下記設定追記

        export LOCATIONTYPE="MYHOME"
                or 
        export LOCATIONTYPE="OFFICE"

    2.6 ConEmu の Commands設定部に下記を記載
    C:\MinGW\msys\1.0\bin\bash.exe --login -i
    (スタートアップディレクトリは環境変数HOMEで決まる） 

        環境変数 HOME　を C:\Users\Norikatsu\Documents に設定

        HOME に .sshを作成しKeyをファイルサーバからコピー
        ConEmuの設定ファイルをロード
        dotfiles\.gitをコピー
        ドットファイルへのリンク作成
        git pull (最新アップデート）

3. Cygwinのインストール
    3.1 デフォルトでインストール

    3.2 設定 Commands設定部に下記を記載

        %SystemDrive%\Cygwin64\bin\bash.exe --login -i
            or
        %SystemDrive%\Cygwin\bin\bash.exe --login -i

    3.3HOMEディレクトリをマウントする
        ・cygwin/home/nori ディレクトリを作成
        ・/etc/fstabに下記行記載
            C:/Users/Norikatsu/Documents /home/nori ntfs override,binary,auto 0 0


4. Puttyの設定
    conohaへの接続設定
    　接続 keepalive を60に設定することを忘れずに
    
    設定エクスポート
    reg export HKEY_CURRENT_USER\Software\SimonTatham\PuTTY c:\putty.reg
    
    設定インポート
    reg import c:\putty.reg

5. リモートサーバへの鍵アップ
    codebreak  -> id_rsa.pub をアップ
    conoha     -> id_rsa.pub とputty生成の Pubキーをアップ


6. dotfilesの設定
    6.1 サーバからクローン
        msys ホームにて
        git clone ssh://norikatsu@git.codebreak.com/norikatsu/dotfiles.git

    6.2 各設定ファイルへのリンクを張る
        管理者権限でCMDを起動
        mklink .bashrc .\dotfiles\.bashrc
        mklink /D .vim .\dotfiles\.vim\
        ......



7. Vagrantインストール
    7.1 VirtualBox, Vagrantインストールはデフォルトパス
    7.2 bash_profileに VirtualBoxのパス追加（すでに記載済み）


    7.3 使い方
        a. vagrant box add NAME URL
            cd 任意のフォルダ
            vagrant box list          -> 現在のboxのリストが表示される
            vagrant box remove NAME   -> boxの削除

        b. vagrant init NAME    カレントにVagrantfileが作成される　これを編集する

        c.  vagrant up  　　　　　起動
            vagrant ssh           ログイン
            vagrant halt          終了

        d.  作業をした任意のフォルダで下記コマンド実行
            vagrant package --output PACKNAME

             上記パッケージの使い方は
            vagrant box add NAME PACKNAME



