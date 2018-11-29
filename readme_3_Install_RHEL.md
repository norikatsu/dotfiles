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

    secure_path に /usr/lobal/bin を追加
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
httpProxy=[proxyserver:port]

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


会社環境ではリポジトリ登録での方法がうまく行かなかったので
直接rpmパッケージをインストールした


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
    # yum install libSM.so.6 libXdmcp.i686
```

下記もインストールしているが、今回はrpmをlocalinstallした
```
    # yum install libSM.i686
    # yum install libXtst.i686
    # yum install libXi.i686
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

/usr/local/Xilinx_LabTools ディレクトリを作成しその下にインストール

Xilinx_LabTools_14.7_1015_1.tar を解凍し
xsetup スクリプトを実行することでインストーラが起動する





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

#### 2018/11/29 に追記 CentOS用の公式パッケージがあるのでこれを使う方が楽
  $ wget https://copr.fedorainfracloud.org/coprs/unixcommunity/vim/repo/epel-7/unixcommunity-vim-epel-7.repo -P /etc/yum.repos.d/
古いvim消す
  $ yum remove "vim*"
  $ yum install vim-enhanced
  $ vim --version
     VIM - Vi IMproved 8.0 (2016 Sep 12, compiled May 22 2017 12:47:09)


#### 以下自前ビルドの方法の説明

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
# vim ~/.bashrc
export WORKON_HOME=~/.virtualenvs
source `which virtualenvwrapper.sh`
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


fontの設定
```
$ cp Ricty.ttf ~/.fonts/
$ cp CicaE.ttf ~/.fonts/
$ sudo yum -y install ipa-gothic-fonts ipa-mincho-fonts ipa-pgothic-fonts ipa-pmincho-fonts
$ sudo yum -y install vlgothic-*
$ fc-cache -vf
```
(EPELリポジトリが無いとエラーになるかもしれないので、22. を参照してEPELリポジトリを先にインストールしておくこと)



### 18 .環境変数設定
```
# vim .bashrc
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

```
#sudo vim /etc/profile
export LOCATIONTYPE=HYMOHE 
or
export LOCATIONTYPE=OFFICE 
```


### 20. リモート時の起動スクリプト
```
~/dotfiles/start_at_mobaxterm.sh
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


### 22. EPEL リポジトリの追加

`http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/7/x86_64/e/ `より  
`epel-release-7-2.noarch.rpm` をダウンロード

```
# sudo yum localinstall epel-release-7-2.noarch.rpm
```

EPELリポジトリはデフォルトで有効化されている。
無効化して、任意指定にする為には以下の設定

```
# vim /etc/yum.repos.d/epel.repo# nano /etc/yum.repos.d/epel.repo

[epel]
enable=0

インストール時の任意指定
$ yum --enablerepo=epel install ????
```


### 23. ファイラー nemo のインストール

```
# sudo yum install nemo
```


### 24. byobu のインストール

```
# sudo yum install byobu
```


### 25. Icarus Verilog のインストール

Icarus Verilogのサイトからダウンロードしておく

ftp://icarus.com/pub/eda/verilog/v0.9/

```
# tar xvfz ./verilog-*.*.*.tar.gz
# cd verilog-*.*.*
# ./configure  --prefix=/usr/lobal/bin
# make
# sudo make install

```



### 26. Lattice Diamond のインストール

Diamond Ver3.9以降が RHEL7に対応  
rpmパッケージを以下の要領でインストールして、  
ライセンスファイルをコピーする  


```
# sudo mkdir /usr/cad/diamond-390
# sudo rpm -Uvh --prefix /usr/cad/diamond-390 ./diamond_3_9-base_x64-99-2-x86_64-linux.rpm
# sudo cp license.dat /usr/cad/diamond-390/diamond/3.9_x64/license

```


### 27. 外付けUSB-HDDのマウントとNTFSへの対応

USB-HDDを接続しても、デフォルトでは自動マウントしない
接続後USBとして認識しているか、確認してデバイスパスを確認する

```
# lsusb 
# sudo fdisk -l
```

これで /dev以下のパスが確認できる。例えば /dev/sdb1となっていたとする

外部HDDがNTFSの場合、mount時のFileTypeをNTFSにする必要があるが
デフォルトでNTFSに非対応なので下記パッケージをインストールする

```
# sudo yum localinstall ntfs-3g-****.rpm

```

下記のようにマウントする (マウントパスは事前に作っておくこと)
```
# sudo mount -t ntfs  /dev/sdb1  /mnt/usbhdd/

```


### 28. ssh 公開鍵方式の設定

RedHat側から LinuxBにログインする場合を想定

```
[Redhat] $ ssh-keygen -t rsa  
```
鍵の名前を聞かれるので、デフォルト"id_rsa" のまま  
パスフレーズは空欄のまま。下記のファイルが生成される  

id_rsa     : 秘密鍵  
id_rsa.pub : 公開鍵  

秘密鍵は ~/.sshの下に配置し、パーミッションは600にしておく
```
[Redhat] $ mv id_rsa ~/.ssh
[RedHat] $ chmod 600 id_rsa 
```

ログイン時のコマンド短縮のため下記設定を ~/.ssh/config ファイルに記入しておく

```
# LinuxB
Host LinuxB                     ( sshコマンドで指定する ホスト名）
    HostName ***.***.***.***    ( LinuxBのIPアドレス）
    User USERNAME               ( LinuxBのアカウント名)
    IdentityFile ~/.ssh/id_rsa  ( 秘密鍵のパス)
    Port 22
    TCPKeepAlive yes
    IdentitiesOnly yes
    ForwardX11 yes
    Compression yes
```


id_rsa.pubを LinuxBに転送し ~/.sshの下に配置  
authorized_keys ファイルに統合する。このファイルのパーミッションは 600にすること
 
```
[LinuxB] $ cat id_rsa.pub >> authorized_keys
[LinuxB] $ rm id_rsa.pub
[LinuxB] $ chmod 600 authorized_keys 
```

これで  ssh ホスト名  だけでログイン可能となる



### 29. rsync によるバックアップの設定

上記 27. で設定した外付けHDD /mnt/usbhdd (の中の Backup/nori-fpga-build )にバックアップを取る設定

```
rsync -auv -delete --safe-links /home/nori /mnt/usbhdd/Backup/nori-fpga-build/
```


上記 28. で設定した外部PC LinuxBの中身を /mnt/usbhdd (の中の Backup/nori-ubuntu) にバックアップを取る設定

```
rsync -auv -delete --safe-links -e ssh nori@LinuxB:/home/nori /mnt/usbhdd/Backup/nori-fpga-build/
```




### 30. crontabのバックアップ自動化

上記 29. の処理を自動化登録

```
$ crontab -e 
```
コマンドでコマンド登録用のvimが起動する。  
下記の様に記載する。下記例では
12:20分 月曜-金曜(1-5)に ローカル /home/noriを usbhddにバックアップ
13:00分 月曜-金曜(1-5)に リモート /home/noriを usbhddにバックアップする処理

20 12 * * 1-5 rsync -au -delete --safe-links --log-file=/home/nori/log/rsync-redhat-`date +"%Y%m%d-%H%M"`.log /home/nori /mnt/usbhdd/Backup/nori-fpga-build/
00 13 * * 1-5 rsync -au -delete --safe-links --log-file=/home/nori/log/rsync-ubuntu-`date +"%Y%m%d-%H%M"`.log -e ssh nori@nori-linux:/home/nori /mnt/usbhdd/Backup/nori-ubuntu/

本来上記記載のままだと ``の区切り、""の区切りによる誤検出で正常に実行されないのでコマンドはスクリプトにまとめて
rsync_redhat.sh, rsync_ubuntu.sh として dotfilesにコミットしておく

cronにはスクリプトを登録して下記のようにする
20 12 * * 1-5 rsync_redhat.sh
00 13 * * 1-5 rsync_ubuntu.sh



### 31. ===== NFS サーバ起動

```
# sudo yum install nfs-server

# sudo systemctl enable rpcbind
# sudo systemctl enable nfs-server

```

ファイアウォールを通すため使用ポートを固定
```
sudo vim /etc/sysconfig/nfs
下記行のコメントアウトを外す
MOUNTD_PORT=892

```


サービスの起動、再起動コマンド
# sudo systemctl start nfs-server
# sudo systemctl restart nfs-server

サービスが起動しているか確認
service nfs status


```

設定ファイルは下記
```
/etc/exports

エクスポートしたいパス    アクセス許可クライアント(オプション) 
/home/nori                nori-linux(rw)
/home/test                192.168.1.3(ro)
/home/test2               192.168.1.4(anonuid=1000,anongid=1000)      <=NFS経由でのアクセス時のUID等を指定する場合

exports変更反映
# sudo exportfs -ar

```

Firewallの設定
ポート 111 と ポート 2049  と ポート 892 の TCP/UDP を許可
```
# sudo firewall-cmd --add-port=2049/tcp --permanent
# sudo firewall-cmd --add-port=2049/udp --permanent
# sudo firewall-cmd --add-port=111/tcp --permanent
# sudo firewall-cmd --add-port=111/udp --permanent
# sudo firewall-cmd --add-port=892/tcp --permanent
# sudo firewall-cmd --add-port=892/udp --permanent
```
・設定を読込みます
# sudo firewall-cmd --reload

・設定を確認します
# sudo firewall-cmd --list-all

以下の表示があればOK
    ports: 111/udp 2049/tcp 2049/udp 111/tcp 892/tcp 892/udp





