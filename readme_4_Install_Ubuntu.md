
===========================================================
○Xorgでログインに設定
ログイン画面の歯車マークをクリックして
Xorg版を選択


===========================================================
○所属グループの確認

id コマンドにアカウント名を引数として与えると所属グループがわかる
ubuntuの管理者だと sudoグループに参加しているはず



===========================================================
○proxy 設定
Ubuntuの場合はUnityで、[システム設定]→[ネットワーク]に[ネットワークプロキシ]という
項目があるので、設定できます。

vi /etc/profile
# 最終行に追記 (プロキシサーバーを環境変数に設定)
MY_PROXY_URL="http://proxy.mei.co.jp:8080/"
export HTTP_PROXY=$MY_PROXY_URL
export HTTPS_PROXY=$MY_PROXY_URL
export FTP_PROXY=$MY_PROXY_URL
export http_proxy=$MY_PROXY_URL
export https_proxy=$MY_PROXY_URL
export ftp_proxy=$MY_PROXY_URL

# apt の個別設定 
 vi /etc/apt/apt.conf  (この設定ファイルは上記システム設定でプロキシを設定すると消えてしまうので作成順序に気をつけること)
# 新規作成
Acquire::http::proxy "http://proxy.mei.co.jp:8080/";
Acquire::https::proxy "http://proxy.mei.co.jp:8080/";
Acquire::ftp::proxy "http://proxy.mei.co.jp:8080/";


===========================================================
○sudo環境へのプロキシ環境変数の引き継ぎ
sudo visudo 
下記設定を追記
Defaults env_keep="http_proxy"
Defaults env_keep+="https_proxy"
Defaults env_keep+="HTTP_PROXY"
Defaults env_keep+="HTTPS_PROXY"


===========================================================
○apt リポジトリ変更
sudo apt-get install openssh-server
$ sudo sed -i.bak -e "s%http://jp.archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
$ sudo apt update
$ sudo apt upgrade

===========================================================
○vim8.0インストール
17.10ではデフォルトリポジトリに vim8.0登録済みなので
リポジトリ追加不要
$ sudo apt install vim-gtk3

それ以前のバージョンではリポジトリ追加する
$ sudo add-apt-repository ppa:jonathonf/vim
$ sudo apt update
$ sudo apt install vim-gtk3


===========================================================
○デフォルトエディタの変更
ubuntuでは 標準のコマンドエディタは alternativesという機構で管理
visudo等はデフォルトでは nanoになっているためviに変更する

sudo update-alternatives --config editor
実行すると 番号で標準エディタが選択できる


===========================================================
○sshdインストール
sudo apt-get install openssh-server



===========================================================
○nVIDIAドライバインストール

画面左上の『アクティビティ』をクリック、softwareと入力、
表示されたソフトウェアとアップデートをクリックして起動し、
「追加のドライバー」タブでドライバーをインストールする。

(一緒に Processor microcode firmware for Intel microcodeもインストールする)


===========================================================
○Chromeインストール
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt update 
sudo apt install google-chrome-stable


===========================================================
○gedit-pluginsインストール

sudo apt install gedit-plugins

画面左上の『アクティビティ』をクリック、geditと入力、表示されたテキストエディターをクリックして起動する。
トップバーのテキストエディター▼をクリック、設定をクリックしてウィンドウを開き、以下のように変更する。
「表示」タブの行番号を表示する、行の右マージンを表示する、カーソルのある行を強調表示するをクリックしてチェックを入れる。
「プラグイン」タブをクリック、必要なプラグインをクリックしてチェックを入れる。


===========================================================
○コーデック インストール
sudo apt install ubuntu-restricted-extras


===========================================================
○Flash plugin インストール
wget http://archive.canonical.com/ubuntu/pool/partner/a/adobe-flashplugin/adobe-flashplugin_20171016.1-0ubuntu1_amd64.deb

ローカル debをインストールするためのソフト gdebiをインストール
sudo apt install gdebi
sudo gdebi abobe-flashplugins****.deb



===========================================================
○ gnome-tweak-tool インストール
sudo apt install gnome-tweak-tool


画面左上の『アクティビティ』をクリック、tweakと入力、
表示されたTweaksをクリックして起動し、ワークスペースをクリック、
静的ワークスペースをクリックする。


===========================================================
○ ワークスペース等の設定

chrome-gnome-shellというツールをインストール
wget https://sicklylife.jp/ubuntu/1710/chrome-gnome-shell_9-0ubuntu1_all.deb
sudo gdebi chrome-gnome-shell_9-0ubuntu1_all.deb


ALT TABにてウィンドウ切り替えに変更する
https://extensions.gnome.org/extension/15/alternatetab/

ページ右側の OFFボタンをクリックすると、インストールが促される
これで ALT-TABがウィンドウ単位の切り替えになる


トップバーからホームフォルダーなどにアクセスできるようにする
https://extensions.gnome.org/extension/8/places-status-indicator/


トップバーからワークスペースを切り替えられるようにする
https://extensions.gnome.org/extension/21/workspace-indicator/



===========================================================
○ 『デスクトップ』『音楽』などの日本語フォルダー名を英語表記にする

env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update



===========================================================
○ ファイル（ファイルマネージャー）のアドレスバーをテキスト形式にする
gsettings set org.gnome.nautilus.preferences always-use-location-entry true






===========================================================
○Icarus Verilog のインストール

Icarus Verilogのサイトからダウンロードしておく
ftp://icarus.com/pub/eda/verilog/v0.9/

コンパイルには flex, bison が必要なのでインストールしておく

```
# sudo apt install flex bison
# tar xvfz ./verilog-*.*.*.tar.gz
# cd verilog-*.*.*
# ./configure    (デフォルトで /usr/local/bin にインストールされる）
# make
# sudo make install

```






===========================================================
○gitインストール 
sudp apt install git

プロキシ設定は上記設定ですでに完了しているので git特別の設定は不要


===========================================================
○svnインストール 
sudo apt install subversion

===========================================================
○ctagsインストール 
sudo apt install ctags



===========================================================
○dotfiles ダウンロード & リンク
 
cd ~
git clone https://github.com/norikatsu/dotfiles.git 
ln -s ./dotfiles/.bashrc .bashrc
ln -s ./dotfiles/.bash_profile .profile    <- Ubuntuでは bash_profileを読み込まないので .profileとしてリンク
ln -s ./dotfiles/.vim .vim
ln -s ./dotfiles/.vimrc .vimrc
ln -s ./dotfiles/.gvimrc .gvimrc
ln -s ./dotfiles/.gitconfig__****** .gitconfig

これで gvim 起動
しばらくダウンロードに時間がかかるので待つ

vimprocのビルド
cd .vim/dein/repos/github.com/Shougo/vimproc
make -f make_unix.mak


sudo vim /etc/profile
下記追記
export LOCATIONTYPE=HYMOHE 
or
export LOCATIONTYPE=OFFICE 


===========================================================
○ntp設定
sudo vim /etc/systemd/timesyncd.conf

#NTP とコメントアウトされている部分を以下の様にする

NTP=ntp0.mei.co.jp

社内のntpサーバは以下の3つ
ntp0.mei.co.jp
ntp1.mei.co.jp
ntp2.mei.co.jp


時刻同期後、以下のコマンドでBIOSの時計を更新
sudo hwclock -w



===========================================================
○フォントインストール

下記パスにフォントファイルをコピー
/usr/local/share/fonts/

下記コマンド実行
sudo fc-cache -fv


===========================================================
○Windows 名前解決

remmina 等のアクセスをPC名で行えるようにするため

sudo apt install winbind
sudo apt install libnss-winbind


sudo vim /etc/nsswitch.conf

下記の様にhosts: 行の末尾に "wins"を追記

hosts:    files mdns4_minimal [NOTFOUND=return] dns wins


remminaの設定
    プロファイルの「名前」は任意、「グループ」空欄、「プロトコル」はRDP

    基本設定の
        サーバはIPアドレスorマシン名
        ユーザー名はWindowsのログイン名 (ドメイン時はPINナンバーのみ）
        パスワードは PCCドメインのパスワード
        ドメインは "pcc-ad.pcc.mei.co.jp

        解像度は任意
        色数は "True color" （これにしないとフォントレンダリングが汚くなる）

    高度な設定
        品質　は最高に（これにしないとフォントが汚くなる）
        サウンドはオフ
        セキュリティはネゴシエーション
        クライアント名、起動プログラム、起動パスは空欄
        チェック欄も空欄


共通の設定画面（メインウィンドの歯車マークをクリック）
    RDPでの詳細設定（カーソルの影など）はレスポンスを見て調整すること





===========================================================
○ファイルサーバマウント

sudo apt install cifs-utils

sudo vim /etc/fstab

以下の様に記述


smb3等に対応するためには下記の様にする
//fs-kita3.japan.gds.panasonic.com/sav1$/tech/devcam  /mnt/devcam cifs username=PINナンバー@japan.gds.panasonic.com,password=PASSWORD,sec=ntlm,iocharset=utf8,rw,uid=1000,gid=1000,vers=3.0,defaults 0 0



実際の記載は下記の様にしている（パスワードのみ隠してある） (versについてはサーバ側で対応しているバージョンにあわせること)

# Filse Server
//fs-minami2.japan.gds.panasonic.com/favc-s44$/n-diad   /mnt/pfdev  cifs username=4006376@japan.gds.panasonic.com,password=PASSWORD,sec=ntlm,iocharset=utf8,rw,uid=1000,gid=1000,vers=1.0,defaults 0 0
//fs-kita3.japan.gds.panasonic.com/sav1$/tech/devcam    /mnt/devcam cifs username=4006376@japan.gds.panasonic.com,password=PASSWORD,sec=ntlm,iocharset=utf8,rw,uid=1000,gid=1000,vers=1.0,defaults 0 0
//fs-minami1.japan.gds.panasonic.com/FAVC-S02$/n-dsc5   /mnt/dsc5   cifs username=4006376@japan.gds.panasonic.com,password=PASSWORD,sec=ntlm,iocharset=utf8,rw,uid=1000,gid=1000,vers=1.0,defaults 0 0
//jp0200swvfa15/bsd-dghome/DesignRoot/current           /mnt/cad    cifs username=4006376@japan.gds.panasonic.com,password=PASSWORD,sec=ntlm,iocharset=utf8,rw,uid=1000,gid=1000,vers=1.0,defaults 0 0


===========================================================
○nemo インストール

sudo add-apt-repository ppa:webupd8team/nemo
sudo apt update
sudo apt install nemo nemo-fileroller
sudo apt install nemo-emblems nemo-filename-repairer nemo-image-converter

リモートログインして nemoを使うと --no-desktop オプションをつけても全画面表示となってしまうため
Ubuntuではリモート時は使えない・・・

またローカル環境で使う場合にも、テーマ変更時に、テーマ設定ファイルが noutilus用に作られているため
イマイチなデザインになってしまう・・・


===========================================================
○nautilus での sftp設定
nautilusの「サーバへ接続」にて
sftp://user@serveraddres
と入力することで接続できる
必要があれば　ブックマーク登録しておく




===========================================================
○vivado インストール

インストーラー実行をsudoで実行すると環境変数が引き継がれないため
-E オプションをつけて実行する


===========================================================
○Xilinx LabTool インストール

インストーラー実行をsudoで実行するとエラーとなるため
一旦自分のホームにインストールしてから /usr/local 下にコピーする

コピー結果が
/usr/local/Xilinx_LabTools/14.7 ....
となるようにコピーする


===========================================================
○Xilinx USBドライバ インストール

sudo apt install fxload libusb-1.0-0 libusb-1.0-0-dev
sudo ln -s /usr/lib/x86_64-linux-gnu/libusb-1.0.so /usr/lib/x86_64-linux-gnu/libusb.so
sudo cp  /usr/cad/Xilinx_LabTools/14.7/LabTools/LabTools/bin/lin64/*.hex /usr/share/
sudo cp  /usr/cad/Xilinx_LabTools/14.7/LabTools/LabTools/bin/lin64/xusbdfwu.rules /etc/udev/rules.d/

sudo vim /etc/udev/rules.d/xusbdfwu.rules 
以下の置換
    %s/TEMPNODE/tempnode/g
    %s/SYSFS/ATTRS/g
    %s/BUS/SUBSYSTEMS/g

リブート後、 lsusb コマンドで Xilinxデバイスが見つかれば認識している

環境変数を設定しておく
export XIL_IMPACT_USE_LIBUSB=1





===========================================================
○Quaruts インストール

setup.shの先頭の実行シェル指定がNGなので
#!/bin/bash
に書き換える


32bitライブラリが必要なので下記をインストール
sudo apt-get install libxft2:i386 libxext6:i386 libncurses5:i386 libsm6:i386 libxtst6:i386 libxi6:i386


Ubuntu17.10では libpng12.so.0が必要だが、debが存在しない
ので違うバージョン用のdebをダウンロードして gdebiでインストールする


usb blaster 用の設定

sudo vim /etc/udev/rules.d/51-usbblaster.rules  (新規作成)
# USB-Blaster
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666" SYMLINK+="usbblaster2/%k"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666" SYMLINK+="usbblaster2/%k"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666" SYMLINK+="usbblaster2/%k"

# USB-Blaster II
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666" SYMLINK+="usbblaster2/%k"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666" SYMLINK+="usbblaster2/%k"


===========================================================
○Diamond (Lattice) インストール

・rpmパッケージを alienコマンドで debに変換する必要がある
alienコマンドはroot権限がないと実行できない。

sudo apt install alien
sudo alien -g --scripts  diamond_3_7-base_x64-96-1-x86_64-linux.rpm
cd diamond_3_7-base_x64-3.7
sudo debian/rules binary

debへの変換は長い時間がかかるので注意


・インストール
cd ..
sudo dpkg -i diamond-3-7-base-x64_3.7-97_amd64.deb



・libpng12のリンク変更
cd /usr/local/diamond/3.8_x64/bin/lin64
sudo mv libpng12.so.0 libpng12.so.0.old
sudo ln -s /usr/lib/x86_64-linux-gnu/libpng12.so.0 libpng12.so.0

・ライブラリのチェック
下記を実行
/usr/local/diamond/3.7_x64/ispfpga/bin/lin64/lmutil lmhostid

そのようなコマンドはないとエラーが出る場合、下記を実行
file /usr/local/diamond/3.7_x64/ispfpga/bin/lin64/lmutil
ここでダイナミックリンクとして要求されている、ld-lsb-x86-64.so.3 が無い
よって下記のようにライブラリのリンクを作成
sudo ln -s /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3





・ライセンスの設定
デフォルトで eth0のMACアドレスを見に行くようになっているが、Ubuntuにはeth0が存在しないので
下記の仮想eth0を作成する(MACアドレスも下記のように設定する）

sudo ip tuntap add dev eth0 mode tap
sudo ip link set dev eth0 address 1c:23:45:67:89:ab

ifconfig -a で追加されていることを確認

毎回コマンドで実行するのが面倒な場合、下記ファイルを作成（まだ未確認）
sudo vim /etc/udev/rules.d/70-persistent-net.rules

SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="1c:23:45:67:89:ab", ATTR{dev_id}=="0x0", ATTR{type}=="1", NAME="eth0"




LatticeのHPでのライセンス申請も上記仮想MACアドレスで申請する
license.dat ファイルを /usr/local/diamond/3.8_x64/license 下にコピーしておく


・アンインストール方法
パッケージ名を " dpkg -l"コマンドで確認
アンインストールは下記コマンド

sudo dpkg -r diamond-**** 






===========================================================
○ xeroxネットプリンタ設定
xeroxのHPからドライバ、とユーティリティ(deb)ファイルをダウンロードして
インストール
　→　残念ながら認証ありの状態で使う方法はわからず





===========================================================
○ テーマインストール for 17.04

テーマインストールスクリプトをダウンロード(ダウンロード先は任意)
git clone https://github.com/tliron/install-gnome-themes ~/tmp/install-gnome-themes

スクリプトを実行
~/tmp/install-gnome-themes/install-gnome-themes

Tweaks上でテーマ、アイコンを選択



===========================================================
○ 環境整備(16.04用の設定)

http://blog.wagavulin.jp/entry/2016/07/03/073247
http://superjeter007.blog.jp/archives/3028716.html
上記サイト参照

sudo apt install compizconfig-settings-manager unity-tweak-tool

unity-tweal-tool で起動する
　ランチャーの場所（左か下）、サイズなど変更
　ウィンドスナップ機能はOFFにしておく


・スクロールバーのサイズを一般的なサイズにする
gsettings set com.canonical.desktop.interface scrollbar-mode normal

（元にもどすには）
gsettings reset com.canonical.desktop.interface scrollbar-mode


・テーマ変更
マテリアルデザインに変更する
sudo add-apt-repository ppa:snwh/pulp
sudo apt update
sudo apt install paper-icon-theme paper-gtk-theme

unity-tweal-tool で
[テーマ]と[アイコン]にてそれぞれ "Paper"を選択する



・時計アプリ
cairo-clock のインストールと起動設定

sudo apt install cairo-clock

Dash で「自動起動」を検索すると、自動起動するアプリケーションの設定ウィンドウが立ち上がる
ここに cairo-clock を登録
オプションは --helpで調べる
例として下記の様に自動起動登録する
cairo-clock --xposition=1800 --width=127 --height=127 --theme=radium --ontop


===========================================================
○ meld(diff ツール）のインストール

sudo apt install meld



===========================================================
○ RabbitVCS(GUI SVN ツール）のインストール

sudo add-apt-repository ppa:rabbitvcs/ppa
sudo apt update
sudo apt install rabbitvcs-nautilus



===========================================================
○ ssh クライアント側としての設定
ローカルを PC-A
サーバを   PC-B
とする

PC-A 
    $ cd ~/.ssh
    $ ssh-keygen -t rsa

        パスフレーズ当は空欄とする
        id_rsa : 秘密鍵
        id_rsa.pub : 公開鍵　ができる

    id_rsa.pub を PC-Bの ~/.sshに置く


PC-B
    ~/.ssh/authorized_keys ファイルに公開鍵をまとめる

    $ cat id_rsa.pub >> authorized_keys
    $ chmod 600 authorized_keys


PC-A
    秘密鍵のパーミッションも変えておく
    $ chmod 600 ~/.ssh/id_rsa


疎通確認
PC-A側からログインする

    $ ssh -l [ユーザ名] -i [秘密鍵のパス] [サーバのホスト名]

一度上記方法でログインすると次からは秘密鍵指定は不要となる


いちいちログインにオプション記載が面倒なので PC-Aの
 ~/.ssh/configに省略設定を記載する

 $ vim ~/.ssh/config

    # FPGA-Buiild
    Host fpga-build                     <- ログイン時の指定ホスト名
        HostName 192.168.1.1            <- 対象マシンのアドレス or 名前
        User nori                       <- ログイン時のユーザー名
        IdentityFile ~/.ssh/id_rsa      <- 秘密鍵
        Port 22                         <- 使用ポート番号
        TCPKeepAlive yes                <- 接続状態を継続したい場合：yes　継続しない場合：no
        IdentitiesOnly yes              <- IdentityFileが必要な場合：yes　必要ない場合：no
        ForwardX11 yes                  <- X11フォワーディングを使う場合には yes
        Compression yes                 <- 上記の際にデータ圧縮を行う際 yes





===========================================================
○ wineインストールと環境整備
下記サイト参考
http://runit.blog.fc2.com/blog-entry-5.html

sudo add-apt-repository ppa:ubuntu-wine/ppa
sudo apt update
sudo apt install wine1.8

export WINEARCH=win32

下記コマンドで設定
winecfg 
ここで MONO と GECKOをインストールするようメッセージが出た場合には
これに従いインストールする

起動後　
アプリケーション タブで Windowsのバージョンを選択（何を選ぶかはその場その場で決める）


次に下記コマンド実行
winetricks

「Select the〜」が選択されているので、そのまま「OK」をクリック
OKを押し続け、選択項目時に一番上の Install a Windows DLL or Componentを選択
あとは dotnet4.0など選択してダウンロードする

フォントは
$HOME/.wine/drive_c/windows/Fonts/ にttcフォントファイルをコピーする




===========================================================
○RS232C (USB)を wine上から使う設定

USB RS232CはLinuxマシンに接続するとすぐに認識する
/dev/下に ttyUSB*が出来上がる

このデバイスは dialout グループになっているので使いたいユーザを
dialoutグループに追加する

sudo gpasswd -a nori dialout

下記コマンドで追加されていることを確認
getent group dialout 


~/.wine/dosdevices 下に /dev/ttyUSB*へのリンクを com*名で作成する

ln -s /dev/ttyUSB0 ~/.wine/dosdevices/com1




===========================================================
○Irfanviewを wine上から使う設定

mfc42.dllをインストール
winetricks mfc42

あとは wine上で ifranviewのインストーラーを実行する
wine iview***_setup.exe









===========================================================
○X11 フォワーディングでの日本語入力設定
fcitx ではできない様子なので ibusを使う
sudo apt install ibus-mozc

リモート環境にて以下の環境変数設定と ibusをデーモンモードで起動

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"

ibus-daemon -d



===========================================================
○デフォルトのalias設定

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'



===========================================================
○マウス環境整備

Logcoolのマウスの場合 Unifying を使うためには下記ツールが必要

$ sudo add-apt-repository ppa:daniel.pavel/solaar
$ sudo apt-get update
$ sudo apt-get install solaar

再起動後、通知領域に solaarのアイコンが表示される



カーソル速度の調整ツール

$ sudo apt install  dconf-editor

$ dconf-editor で起動する（Windowsのregieditのような階層構造になっている）

    org > gnome > desktop > peripherals > mouse 
        上記数値を -1.0 ~ 1.0 に調整することで速度を変えられる (1.0が最速）



===========================================================
○VirtualBox 

aptコマンドでインストールすること
Extensin PackをWEBサイトからダウンロードしてインストールすること
ここで 本体のバージョンと揃える必要あり
(20170530時点の Ubuntu 16.04では 5.0.40 になっているので注意）

本体インストール後 Extension Packをダブルクリックでインストールされる


ゲストのWindows上で "Guest Addition"をインストールする


USBを使えるようにするため virtualboxグループにユーザーを参加させる
# sudo gpasswd -a USERNAME voxusers


===========================================================
○modernIE
modernIEの設定 - USBの設定で "USBデバイスフィルター"を追加して
デバイスとして USB-232C変換機を登録する (他のFPGA書き込み機はLinux経由で使うため登録しない）

IE のプロキシ設定
Acrbatインストール
ブックマーク保存
Zドライブに devcam登録


日本語環境をセットアップ
    Windows+Iキーを押して設定チャームを開き、画面右下の[Change PC settings]をクリック
    [PC Settings]画面左の[Time and language]をクリック
    [Time and language]画面左で[Region and language]をクリック
    画面右の[Country and region]ドロップダウンを[Japan]に変更
    [Language]セクションで[Add a language]をクリック
    [Add a language]画面で[日本語]をクリック
    [Time and language]画面に戻ると[Languages]セクションに[日本語]が追加され、その下の表示が[language pack available]に切り替わります。
    [日本語]をクリックし、[Set as primary]ボタンを押す
    再度[日本語]をクリックし、[Options]ボタンを押す。
    [日本語]画面の[Download language pack]の下の[Download]ボタンを押す。
    Windowsキーを押してStart画面を表示し、右上のIEUserをクリックし、ポップアップメニューの[Sign out]を押す。
    マウスをクリックして、サインイン画面を表示し、パスワード欄にPassw0rd!と入力してエンターキーを押す。
    Start画面のStartが日本語で「スタート」と表示されていればOK
    これで、日本語を入力、表示できるようになりました。


キーボードの設定

コマンド指定して実行で
"mmc devmgmt.msc"

起動後下記編集
「Keyboards」の「Standard PS/2 keyboard」の「Properties」をクリックします。
「Driver」の「Update Driver…」をクリックします。
「Browse my computer for driver software」をクリックします。
「Let me pick from a list of device drivers on my computer」をクリックします。
「Show compatible hardware」のチェックを外し、「Manufactuer」で「(Standard keyboards)」を選択し、「Japanese PS/2 Keyboard (106/109 Key)」を選択して「Next」をクリックします。
ドライバの確認が行われるので「Yes」をクリックします。



===========================================================
○ Skype for Buisiness

pidgin をインストール

# sudo apt install pidgin
# sudo apt install pidgin-sipe

Linuxを再起動する

pidgin を起動後アカウント追加

    Base タブ
        Protocol : Office Communicator
        Username : yoshida.norikatsu@palet.jp.panasonic.com
        Login    : PCC-AD\PINナンバー
        Password : 上記のパスワード

    Advancedタブ
        Server   : 空欄
        Connection type : Auto
        User Agent : UCCAPI/15.0.4420.1017 OC/15.0.4420.1017
        Authentication scheme : TLS-SDK

以上で接続できる


    自動起動設定
    $ gnome-session-properties
    で自動起動するアプリの設定が開くので pidginを追加する



===========================================================
○ NFS マウント

NFSクライアントをインストール
# sudo apt install nfs-common


NFSサーバ側の状態を確認
# showmount -e IPaddrs

/etc/fstab

Server:/PATH   /mnt/tmp  nfs  defaults 0 0




