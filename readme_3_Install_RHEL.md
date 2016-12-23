# Linux 環境のソフトのインストール方法説明
---

## 概要
Linux環境として RHEL7.2をインストールし
Vivado, Quartusのインストール
日本語環境、vim環境を整備する
---



### 1. ===== RHELのインストール
a. パーティション /boot はデフォルト、/homeは削除、/ にすべてまとめる  
b. インストールソフト 開発環境を選択  
   グループは シンプルを選択しておく（後でGUIログインが可能になる。今後通常起動はCUI起動でOKなハズのため)


### 2. ===== sudo有効化
```
# visudo
    user    ALL=(ALL)   ALL
```

### 3. ===== ロケール設定
```
# localectl set-keymap jp106
# localectl set-locale LANG=ja_JP.utf8
# localectl status
```

### 4. ===== タイムゾーン
```
# timedatectl set-timezone Asia/Tokyo
# timedatectl status 
```

### 5. ===== IPアドレス設定
```
# nmcli device
# nmcli device show eno1*****
# nmcli conn mod eno1**** ipv4.method manual ipv4.addresses 192.168.1.81/24 ipv4.gateway 192.168.1.1 ipv4.dns "8.8.8.8 8.8.4.4"
```

### 6. ===== proxy設定
```
# vi /etc/sysconfig/rhn/up2date

enableProxy[comment]=Use a HTTP Proxy
enableProxy=1
httpProxy=
```

subscriptionのプロキシ設定
```
# subscription-manager config –server.proxy_hostname=[proxyserver] –server.proxy_port=[portNumber]
```

### 7. ===== subscription
```
# subscription-manager list

# subscription-manager register
ユーザー名: xxxxxxxx
パスワード:
システムは id で登録されています:xxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# subscription-manager list --available
+-------------------------------------------+
    利用可能なサブスクリプション
+-------------------------------------------+
サブスクリプション名:     Red Hat Enterprise Linux Server, xxxxxxxxxxx
SKU:                    RHxxxxxxxxxx
プール Id:                 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
数量:                     1
サービスレベル:                Premium
サービスタイプ:                L3
複数エンタイトルメント:            No
終了日:                    20xx年0x月0x日
システムのタイプ:               物理

# subscription-manager subscribe --pool=xxxxxxxxxxxxxxxxxxxxxxxxxx
サブスクリプションが正しく割り当てられました: Red Hat Enterprise Linux Server, xxxxxxxxxxxxxxx
```

登録内容の確認方法
```
# subscription-manager list
```

サブスクリプション有効化後 yumが使えるようになる  
最低限必要なパッケージをインストールしておく

```
# yum check-update

# yum install screen
# yum install svn
# yum install git
```


### 8. ===== GUI設定

```
# yum groups file
# yum -y groupinstall "Server with GUI"
# systemctl set-default graphical.target
# systemctl get-default
```


### 9. ===== vmware tools openのインストール

```
# yum install open-vm-tools
```

もしyum がlockしている場合には下記コマンド実行
```
rm -f /var/run/yum/pid )
```


### 9.1 ==== vmware MACアドレス固定

インストール完了後 
Linux上で MACアドレスを確認
この値を ***.vmxファイルに反映

```
# ethernet0.addressType = "generated"
ethernet0.addressType = "static"
ethernet0.Address = "AB:CD:EF:12:34:56"
```

これで MACアドレスが固定されるため イメージをコピーしても
アドレスが変わることはない



### 10. ===== chromeのインストール

googleのリポジトリを登録
```
# vi /etc/yum.repos.d/google.chrome.repo

[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
```

アップデートしてインストール

```
# yum update
# yum install google-chrome-stable
```

    ===== root権限で利用するためには
    # vi /opt/google/chrome/google-chrome
    一番下の行を変更

    google-chrome
    else
        exec -a "$0" "$HERE/chrime" "$@" --user-data-dir=~
    fi

    ===== エラーが出る場合
    「ERROR:nacl_fork_delegate_linux.cc(315)」というエラーが出る場合

    # vi /opt/google/chrome/google-chrome
    一番下の行を変更

    google-chrome
    else
        exec -a "$0" "$HERE/chrime" "$@" --no-sandbox --user-data-dir=~
    fi


### 11. ===== Quartus131のインストール

必要パッケージのインストール

```
    # yum install glibc.i686 libXext.i386 libX11.i386 libXau.i386 libXdmcp.i386 freetype.i386 fontconfig.i386 and expat.i386
```

quartus13.1のtarを解凍してから `# ./setup.sh` 実行  
インストールディレクトリとパッケージをcuiで選択  
/usr/cad/quartus131 をインストール先に選択  

libpngでエラーが出る場合には `# yum install libpng12.i686`をインストール


### 12. ===== Quartus161のインストール

quartus161のtarを解凍してから `# ./setup.sh` 実行  
GUIインストーラーにてインストール先を選択  
/usr/cad/quartus161 をインストール先に選択  

ModelSimでエラーが発生するので下記パッケージをインストール
```
# yum install libpng12.i686
# yum install libX11.i686
# yum install libXext.i686
# yum install libXft.i686
# yum install ncurses-libs.i686
```


### 13. ===== Vivado2016.3のインストール
    
Xilinx_Vivado_SDK_2016.3_*****.bin  
上記プログラムダウンローダーでバイナリダウンロード  
ダウンロード後インストーラーを実行  

GUIインストーラーにてインストール先を /usr/cad/vivado2016.3に選択  

### 14. ===== Vivado2014.* のインストール
    
Xilinx_Vivado_SDK_2014.2_*****.bin  
上記プログラムがインストーラー  
GUIインストーラーにてインストール先を /usr/cad/vivado2014.2に選択  


### 15. ===== xilinxデザインツールをインストール





### 16. ===== 日本語入力設定

#### fcitxのインストール
ディストリビューション  
Fedora 19 for x86_64 用をダウンロードする  
```
fcitx-4.2.8-1.fc19.x86_64.rpm
fcitx-data-4.2.8-1.fc19.noarch.rpm
fcitx-gtk2-4.2.8-1.fc19.x86_64.rpm
fcitx-gtk3-4.2.8.1.fc19.x86_64.rpm
fcitx-libs-4.2.8-1.fc19.x86_64.rpm
```

GNOME用の設定ツール  
```
fcitx-configtool-0.4.7-1.fc19.x86_64.rpm
unique-1.1.6-9.fc19.x86_64.rpm
```

KDE等のQt系の場合
```
kcm-fcitx-0.4.1-2.fc19.x86_64.rpm
```

インストールは依存関係解消のためまとめて行うこと
```
# yum localinstall fcitx-*** fcitx-data-*** fcitx-gtk2-*** fcitx-gtk3-*** fcitx-libs-***
# yum localinstall fcitx-configtool-*** unique-1.1.6-9.fc19.x86_64.rpm
```

#### mozcのインストール
mozc Fedora19とopenSUSE用をダウンロードする  

    Fedora19
    protobuf-2.5.0-4.fc19.x86_64.rpm
    zinnia-0.06-16.fc19.i686.rpm
    zinnia-0.06-16.fc19.x86_64.rpm
    zinnia-tomoe-0.06-16.fc19.x86_64.rpm

    openSUSE
    mozc-1.15.1868.102-1.4.x86_64.rpm
    fcitx-mozc-1.15.1868.102-1.4.x86_64.rpm
    mozc-gui-tools-1.15.1868.102-1.4.x86_64.rpm


インストールは依存関係解消のためまとめて行うこと
```
# yum localinstall protobuf-2.5.0-4.fc19.x86_64.rpm zinnia-0.06-16.fc19.i686.rpm \
      zinnia-0.06-16.fc19.x86_64.rpm \
      zinnia-tomoe-0.06-16.fc19.x86_64.rpm mozc-1.15.1868.102-1.4.x86_64.rpm \
      fcitx-mozc-1.15.1868.102-1.4.x86_64.rpm mozc-gui-tools-1.15.1868.102-1.4.x86_64.rpm
```


fcitxへの切り替え
```
$ gsettings set org.gnome.settings-deamon.plugins.keyboad active false
$ imsetting-swich fcitx
```

fcitxの設定
```
$ fcitx-configtool
```
ここで インライン入力が有効か確認する  
[アドオン]-「拡張」にチェック  
Fcitx XIM Frontendの Provides XIM supportにチェックを入れる  
Fcitxの切り替えキーバインドは[全体の設定]で行うコト  


mozcの設定

```
$ /usr/lib64/mozc/mozc_tool --mode=dictionary_tool
```
これでmozcの辞書登録ツールが起動する
そのたオプションは検索すること


### 17. ===== vim インストール

#### 必要パッケージと,luaとpythonを事前にインストールする  
```
# yum install lua
# yum install gtk2-devel
# yum install ncurses-devel
# yum install libacl-devel 
# yum install libSM-devel 
# yum install libXt-devel 
# yum install libXpm-devel 
```

lua-devel-5.1.4-15.el7.x86_64.rpm をローカルインストール
```
# yum localinstall lua-devel-5.1.4-15.el7.x86_64.rpm
```

#### wgetのproxy設定
```
$ vim ~/.wgetrc
http_proxy=http://proxy.mei.co.jp:8080/
```

#### Pythonのインストール  
python2 3切り替えのために pip等をインストール  
```
$ wget http://bootstrap.pypa.io/get-pip.py
$ sudo  ./get-pip.py

$ sudo pip --proxy=http://proxy.mei.co.jp:8080 install virtualenv
$ sudo pip --proxy=http://proxy.mei.co.jp:8080 install virtualenvwrapper
```


~/.bashrc に下記を記述
```
# vim ~/.bshrc
export WORKON_HOME=~/.virtualenvs
source`whichvirtualenvwrapper.sh`
```


pythonビルドに必要なパッケージ準備  
```
# yum groupinstall "Development tools"
# yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
```

pythonソースコードダウンロード & ビルド  
```
$ curl -O https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
$ curl -O https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
$ tar zxf Python-2.7.11.tgz
$ tar zxf Python-3.5.2.tgz

$ cd Python-2.7.11
$ ./configure --prefix=/opt/python2.7.11
# make
# sudo make altinstall

$ cd Python-3.5.2
$ ./configure --prefix=/opt/python3.5.2
# make
# sudo make altinstall
```

Python2,3を切り替えるためのツールの使い方
```
$ mkvirtualenv --python <使用するPythonのパス> <環境名>
$ mkvirtualenv --python /opt/python2.7.11/bin/python2.7 env_27
$ mkvirtualenv --python /opt/python3.5.1/bin/python3.5 env_35

$ workon <環境名> で切り替え
$ workon          で環境一覧表示
$ deactivate        環境停止
$ rmvirtualenv <環境名> 環境削除
```

#### git のproxy設定
```
$ vim .gitconfig

[http]
    proxy = http://proxy.mei.co.jp:8080
[https]
    proxy = http://proxy.mei.co.jp:8080
```


#### vimリポジトリよりダウンロード
```
$ git clone https://github.com/vim/vim.git

$ ./configure --enable-multibyte
              --enable-xim
              --enable-fontset
              --disable-selinux
              --with-features=huge
              --prefix='/usr/local/vim-8.0'
              --with-x=yes
              --enable-gui=gtk2
              --enable-luainterp=yes
              --enable-python3interp
              --with-python3-config-dir=/opt/python3.5.1/lib/python3.5/config-3.5m
              --enable-fail-if-missing

$ make

$ sudo make install

$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/vim
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/gvim
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/view
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/eview
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/evim
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/ex
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/gview
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/gvimdiff
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/rgview
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/rgvim
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/rview
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/rvim
$ sudo ln -s /usr/local/vim-8.0/bin/vim /usr/local/bin/vimdiff
```

元々インストールされていた vimは "/usr/bin/vim "で念のためそのままにしておく  
PATHの優先順位で /usr/local/binが優先される  



### 18 .環境変数設定
```
    export NO_AT_BRIDGE=1                   // SSHリモート時の dbudエラーを表示しないようにするため

    export GTK_IM_MODULE=fcitx              // SSHリモート時にfcitxを使えるようにするコマンド
    export QT_IM_MODULE=fcitx               //
    export XMODIFIERS="@im=fcitx"           //
    export DefaultIMModule=fcitx            //
```

### 19. dotfile入手
```
$ git clone https://github.com/norikatsu/dotfiles.git 
```

### 20. リモート時の起動スクリプト
```
fcitx -d
```
gnome-terminal, screen と同じタイミングでfcitxも起動するスクリプトを用意する


### 21. githubへのアクセス設定

githubは二段階承認設定のためpushのためにアクセストークンを用意する必要あり  
トークンは githubの settingで生成する  

ホームディレクトリに以下の設定ファイルを用意する

```
# vim .netrc

machine github.com
login norikatsu
passwd [personalaccesstoken]
```