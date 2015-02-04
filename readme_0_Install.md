# Linux & Windows環境のソフトのインストール方法説明
---

## 概要
Linux環境は CentOS5 64bit をメインに想定。  
会社の環境ではProxyの設定が必要なので readme_setting.txtを参照すること  

## rpmforge リポジトリの追加 (for CentOS)

### sudo 設定

```
$ su -
# visudo
```

```user   ALL=(ALL) ALL``` を追加するuserは権限を与えたいユーザ名


### ファイルの取得

```
$ cd /usr/local/src
$ sudo wget http://dag.wieers.com/packages/rpmforge-release/rpmforge-release-?????.rpm
$ sudo wget http://dag.wieers.com/packages/RPM-GPG-KEY.dag.txt
```

### rpmパッケージのインストール

```
$ sudo rpm -ivh rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
```

### enabledに0を設定。
yumコマンドで今追加したリポジトリを常時参照するのではなく必要な時だけ使うための設定。

```
$ sudo vim /etc/yum.repos.d/rpmforge.repo
```

```
enabled = 0
```
---
## Linuxソフトインストール方法

### Git インストール方法

```
$ sudo yum -y --enablerepo=rpmforge install git git-svn
```

会社ではプロキシ設定が必要
プロキシサーバ ```proxy.mei.co.jp:8080```
基本的な http等のプロキシ設定は .bash_profile内で行われている
Linuxでは 別にdotfileを用意することでプロキシー設定するソフトもある (後述）

### yum の設定
/etc/yum.confの[main]セクションにに下記の１行を追加。

```
[main]
proxy=http://proxy.mei.co.jp:8080/
```

### wget の設定
~/.wgetrc に設定が記述されている
会社のLinuxでは  ~/.wgetrc_office_linux に対するソフトリンク張ること


### Gitの設定

GitプロトコルでProxyを経由する為には corkscrew をインストールする必要がある

#### corkscrewのインストール

```
wget http://www.agroman.net/corkscrew/corkscrew-2.0.tar.gz
tar zxvf corkscrew-*.*.tar.gz
cd corkscrew-*.*
./configure
make
sudo make install
```

#### /usr/local/bin/git-proxy ファイルを作成

```
!/bin/bash
CORKSCREW=`which corkscrew`
$CORKSCREW [ProxyServerAddress] [ProxyServerPort] $1 $2
```

作成ファイルに実行権限を与える

```
sudo chmod 755 /usr/local/bin/git-proxy
```

#### 環境変数を設定 (.bash_profile内で行われている)

```
export GIT_PROXY_COMMAND=/usr/local/bin/git-proxy
```

### Mercurial インストール
VIM 等は Mercurialで管理されているので、このインストールが必要

```
$ sudo yum -y --enablerepo=rpmforge install mercurial
```

プロキシ設定は ~/.hgrc で行う。  
Office のLinuxでのみ有効にする為 ~/.hgrc_office_linux に対してリンクを張ること



### Python3 インストール方法 for RedHat5

#### ダウンロード
 Python3.3をダウンロード

```wget http://www.python.org/ftp/python/3.3.0/Python-3.3.0.tgz```

#### ビルド

```
tar zxvf Python-3.3.0.tgz
cd Python-3.3.0
./configure \
--prefix=/usr/local/python \
--enable-shared
make
```

#### インストール

```
sudo make install
```

/etc/ld.so.conf に下記行を追加

```
/usr/local/python/lib
```

rootで下記コマンド実行
```
su -
ldconfig
```

```
ln -s /usr/local/python/bin/python3 /usr/local/bin/python3
```



### VIM インストール方法
事前に Mercurialをインストールしておくこと
#### ダウンロード

```
$ hg clone https://vim.googlecode.com/hg/ vim
```

#### ダウンロードした vimディレクトリに移動し configure 実行

RedHatなどの場合
```
$ ./configure --enable-multibyte --enable-xim --enable-fontset --disable-selinux --with-features=huge --prefix='/usr/local/vim-7.4' --enable-luainterp=yes
```

Ubuntuの場合
```
$ ./configure --enable-multibyte --enable-xim --enable-fontset --disable-selinux --with-features=huge --prefix='/usr/local/vim-7.4' --enable-luainterp=yes --with-lua-prefix=/usr
```

Pythonを有効にする設定  
python3-dev パッケージが必要  
python のconfigディレクトリを確認  

```
python -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LIBPL')"
python3 -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_var('LIBPL'))"
```

configディレクトリを指定すること (python2側は自動で見つける場合が多いので記述無し)
```
./configure --with-features=huge --enable-multibyte --disable-selinux --prefix='/usr/local/vim-7.4' --enable-gui=gtk2 --enable-perlinterp --enable-pythoninterp --enable-python3interp  --with-python3-config-dir=/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu  --enable-rubyinterp --enable-tclinterp --enable-luainterp=dynamic --with-lua-prefix=/usr --enable-gpm --enable-acl --enable-cscope --enable-fontset --enable-xim --enable-fail-if-missing
```

以下はRedHat5での場合（python3のlibディレクトリは上記コマンドで確認すること）
```
./configure --enable-multibyte --enable-xim --enable-fontset --disable-selinux --with-features=huge --prefix='/usr/local/vim-7.4' --enable-luainterp=yes --enable-python3interp  --with-python3-config-dir=/usr/local/python/lib/python3.3/config-3.3m
```


#### make 実行

```
$ make
```

#### 既存のvimをアンインストール

```
$ sudo yum remove vim-enhanced
```

#### インストール
```
$ sudo make install
```

#### 元インストール先のvimパス(/usr/bin/vim) にリンクを張る(実態は全て vimでよい)
```
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
```

#### /usr/bin/vi の無効化
bashrc でエイリアス指定

```
alias vi='vim'
```

SVNのEDITOR にvimを指定

```
export SVN_EDITOR=vim
export EDITOR=vim
```


#### 日本語IMEの設定
Linux環境でノーマルモード時に日本語モードをOFFにする設定を行う
処理には "xvkbd"を用いる

##### SCIMのキーバインド設定
SCIM OFF に <SHIFT>+<CTRL>+<SPCACE>  を設定
##### xvkbd のインストール

```
$ wget http://homepage3.nifty.com/tsato/xvkbd/xvkbd-3.2.tar.gz 

解凍フォルダ内で以下実行
$ xmkmf
$ make
$ sudo make install
```



### m4 インストール
SCREENのインストールに最新版が必要となる

#### wgetで rpmソースを入手しビルドする (会社の環境ではProxyの設定が必要）
```
$ wget ftp://ftp.riken.go.jp/Linux/fedora/releases/11/Fedora/source/SRPMS/m4-1.4.12-2.fc11.src.rpm
$ sudo mkdir -p /usr/src/rehdat/SOURCES
$ sudo rpm -ivh --nomd5 m4-1.4.12-2.fc11.src.rpm
$ cd /usr/src/redhat/SPECS
$ sudo yum install rpm-build
$ sudo rpmbuild -ba m4.spec
$ cd ../RPMS/i386
$ sudo rpm -Uvh m4-1.4.12-2.XXXXXX.rpm   <- (32bitでは i386、64bitでは x86_64)
```

#### ソースコードからのインストール（通常は不要）
```
$ wget ftp://ftp.gnu.org/gnu/m4/m4-1.4.10.tar.gz
$ tar zxvf m4-1.4.10.tar.gz
$ cd m4-1.4.10
$ ./configure --prefix=/usr/local/
$ make
$ make install
```

### autoconf インストール
SCREENのインストールに バージョン2.6* 必要となる
autoconf 2.6*のビルドには m4が必要なので事前にインストールすること
wgetで rpmソースを入手しビルドする (会社の環境ではProxyの設定が必要)
```
$ wget ftp://ftp.riken.go.jp/Linux/fedora/releases/11/Fedora/source/SRPMS/autoconf-2.63-2.fc11.src.rpm
$ sudo rpm -ivh --nomd5 autoconf-2.63-2.fc11.src.rpm
$ cd /usr/src/redhat/SPECS
$ sudo rpmbuild -ba autoconf.spec
$ cd ../RPMS/noarch
$ sudo rpm -Uvh autoconf-2.63-2.noarch.rpm
```

### screen インストール
SCREEN のインストール時には emacs,autoconfが必要なので事前にインストールすること  
emacs インストール (yumでOK)  

screenビルド
```
$ git clone git://git.savannah.gnu.org/screen.git
$ cd screen/src
$ autoconf
$ autoheader
$ ./configure --prefix=/usr/local --enable-colors256
$ make && sudo make install
$ sudo cp ./etc/etcscreenrc /usr/local/etc/
```

Cygwin版の補足事項
デタッチ、アタッチを使うために 環境変数 CYGWIN に ttyを設定すること  
cygtermではcygterm.cfg に以下の記述をする事  
```
ENV_2  = CYGWIN="tty codepage:utf8"
```


### Subversionのインストール
Windows の TortoiseSVNとLinuxのコマンドライン版のバージョンをそろえる目的で  
1.6系をLinuxにインストールする

#### インストール
```http://www.collab.net/downloads/subversion/ ``` より CollabNet版のSubversionをダウンロードする

CollabNetSubversion-client-1.6.16-1.x86_64.rpm を手動でインストール

#### svn へのリンク作成
古い svn /usr/bin/svn を 削除 or リネームし  
/opt/CollabNet_Subversion/bin/svn に対する リンクを /usr/bin/svn に貼る  

```
sudo mv /usr/bin/svn /usr/bin/svn_ver1.4.2
sudo ln -fs /opt/CollabNet_Subversion/bin/svn /usr/bin/svn
```

#### Windows側 TortoiseSVN のバージョンをそろえる

TortoiseSVN-1.6.15.21042-win32-svn-1.6.16 をインストール

### QuartusII for Linux のインストール方法
この文章は 「開発G版」についての記述である
中身はオリジナルと一緒 インストーラ無しでパッチ済み

#### インストーラ の場所
```
\\fs-kita3.japan.gds.panasonic.com\sav2$\eda\lsi-wg\archive\alt
```
上記統合ファイルサーバの場所を mnt する

#### インストール方法
```
$ mkdir /usr/local/altera
$ cd /usr/local/altera
$ tar zxvf /mnt/sav2/*****/quartus-100_sp1.tgz
$ mkdir /usr/cad
$ ln -s /usr/local/altera/quartus-100/ /usr/cad/quartus-100
```

#### 環境変数の設定
ライセンスサーバ、QUARTUS_ROOTDIR 、PATHの3つの設定を行う
この設定は ~/.bash_profile 内にで記述してある

```
export LM_LICENSE_FILE=1700@133.181.137.195
export QUARTUS_ROOTDIR=/usr/cad/quartus-100/quartus
export PATH=$PATH:$QUARTUS_ROOTDIR/bin
```

### Quest (Modelsim) for Linux のインストール方法

#### インストーラ の場所
```
\\fs-kita3.japan.gds.panasonic.com\sav2$\eda\lsi-wg\archive\mentor\questa\questa-66c.tgz
```

#### インストール方法
```
$ mkdir /usr/local/menter
$ cd /usr/local/menter
$ tar zxvf /mnt/sav2/*****/questa-66c.tgz
$ mkdir /usr/cad （QuartusIIインストール時に作っていたら不要）
$ ln -s /usr/local/menter/questa-66c /usr/cad/questa-66c
```

#### 環境変数の設定
ライセンスサーバ、MODEL_TECH 、PATHの3つの設定を行う
この設定は ~/.bash_profile 内にで記述してある
```
export LM_LICENSE_FILE=1717:@132.182.83.174 (追加するように記述すること)
export MODEL_TECH=/usr/cad/questa-66c/questasim
export PATH=$PATH:$MODEL_TECH/bin
```

#### FPGAライブラリ設定
LinuxでQuesta(Modelsim)を使用するときに必要な Altera用ライブラリのインストール方法
（単純にAltera版の Modelsimをインストールします）

アーカイブを下記フォルダにアップ済み
```
fs-kita3.japan.gds.panasonic.com\sav1$\tech\devcam\【永久保管】COMMON\C-技術資料、シンポジューム\C-FPGA技術資料\Altera\QuartusIIインストールプログラム\QuartusII10.0SP1Linux(Modelsimのみ)
```

Altera版ModelSimインストール
```
$ sudo chmod a+x 10.0sp1_modelsim_ase_linux.sh
$ sudo 10.0sp1_modelsim_ase_linux.sh 
Destinaton Directory:インストール先は以下のようにしました
/usr/local/altera/modelsim_ase-100sp1
```

Questaは参照ライブラリに対する書き込み属性が必要なのでパーミッション変更
```
$ sudo chmod -R 777 /usr/local/altera/modelsim_ase-100sp1/modelsim_ase/altera
```

#### GCC へのリンクを作成
MODEL_TECH 下にGCCへのリンクは作成（rebuildから呼び出されるMakefileが参照するため）
```
$ sudo mkdir ${MODEL_TECH}/gcc-4.0.2-linux
$ sudo mkdir ${MODEL_TECH}/gcc-4.0.2-linux/bin
$ sudo ln -s /usr/bin/gcc ${MODEL_TECH}/gcc-4.0.2-linux/bin/gcc
```

---

## Windowsソフトインストール方法

### ProgramFilesのコピー
+ vim, 7zip ConEmu は32bit、64bitで異なるので注意  
+ TortusSVN, WinMerge, VLC のインストール（64,32とも デフォルトの"Program Files"にインストール  
+ vim のフォルダには ctags と verilotor を同梱する(パスを通す必要が無いため)  


### MinGWとGitのインストール

+ MinGw環境を C:\MinGW にインストール
    msys 環境作り
+ Git for Windows を C:\MinGW\Git にインストール
    文字コードはそのままを選択

+ 下記空フォルダを作成
    ```"C:\MinGW\msys\1.0\mingw\" ```

+ C:\MinGW\msys\1.0\etc\fstab を用意下記設定  
    ``` c:/MinGW        /mingw```

+ C:\MinGW\msys\1.0\etc\profile に下記設定追記  

```
        export LOCATIONTYPE="MYHOME"
                or 
        export LOCATIONTYPE="OFFICE"
```

+ ConEmu の Commands設定部に下記を記載  
    C:\MinGW\msys\1.0\bin\bash.exe --login -i  
    (スタートアップディレクトリは環境変数HOMEで決まる）  

環境変数 HOMEを C:\Users\Norikatsu\Documents に設定

HOME に .sshを作成しKeyをファイルサーバからコピー  
        ConEmuの設定ファイルをインポート(ConEmu.xml)  
        dotfiles\.gitをコピー  
        ドットファイルへのリンク作成  
        git pull (最新アップデート）  



### Puttyのインストール

プライベートキーに .pkkを選択した設定を保存しておくこと

>設定エクスポート
>reg export HKEY_CURRENT_USER\Software\SimonTatham\PuTTY c:\putty.reg
>
>設定インポート
>reg import c:\putty.reg
>conohaへの接続設定
>
>接続 keepalive を60に設定することを忘れずに



### リモートサーバへの鍵アップ
codebreak  -> id_rsa.pub をアップ  
conoha     -> id_rsa.pub とputty生成の Pubキーをアップ  
conohaはssh接続を コマンドでする場合には id_rsa.pubを使用(sshコマンドベース)
Puttyで接続する場合には *.pkkを使用する



### dotfilesの設定
#### サーバからクローン
msys ホームにて
```
git clone ssh://norikatsu@git.codebreak.com/norikatsu/dotfiles.git
```

各設定ファイルへのリンクを張る
管理者権限でCMDを起動
```
mklink .bashrc .\dotfiles\.bashrc
mklink /D .vim .\dotfiles\.vim\
......
```



### Vagrantインストール
+ VirtualBox, Vagrantインストールはデフォルトパス  
+ bash_profileに VirtualBoxのパス追加（すでに記載済み）  


#### 使い方

```
vagrant box add NAME URL  
cd 任意のフォルダ
vagrant box list          -> 現在のboxのリストが表示される
vagrant box remove NAME   -> boxの削除
```

```
vagrant init NAME    カレントにVagrantfileが作成される これを編集する  

vagrant up            起動
vagrant ssh           ログイン
vagrant halt          終了
```

```
作業をした任意のフォルダで下記コマンド実行
vagrant package --output PACKNAME

 上記パッケージの使い方は
vagrant box add NAME PACKNAME
```



### VMware Playerのインストール
通常にインストールするだけ
しかし ネットワーク設定用の vmnetcfg.exe がそのままではインストールされない  
インストーラから抽出する必要がある  

```
C:\>VMware-player-3.0.0-203739.exe /e .\extract
```

これにより、extract というディレクトリができ、その下に network.cab がある  
これを展開すると vmnetcfg.exe が取り出せる。  
このファイルをVMWare Player3.0がインストールされているディレクトリにコピー  
(他のディレクトリだと、dllのエラーがでて動かない)  



### WOL のインストール
BIOSで電源管理部の "S5状態から起動" と "ブートのネットワークブート" 以上2カ所を有効にしておく  
Windows アプリケーション "wol"をインストール  
ブートしたいPCの MACアドレス、マシン名を登録  
Windowsでショートカットを作成  

```
"C:\Program Files\wol\wol.exe" -wake nori-linux    <- ここで nori-linux がブートしたいPCの名前
```

作成したショートカットダブルクリックで起動する


 
