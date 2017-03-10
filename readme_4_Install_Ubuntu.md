
===========================================================
○所属グループの確認

id コマンドにアカウント名を引数として与えると所属グループがわかる
ubuntuの管理者だと sudoグループに参加しているはず


===========================================================
○デフォルトエディタの変更
ubuntuでは 標準のコマンドエディタは alternativesという機構で管理
visudo等はデフォルトでは nanoになっているためviに変更する

sudo update-alternatives --config editor
実行すると 番号で標準エディタが選択できる


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
○sshdインストール
sudo apt-get install openssh-server


===========================================================
○Chromeインストール
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt-get update 
sudo apt-get install google-chrome-stable


===========================================================
○vim8.0インストール
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim-gtk3


===========================================================
○gitインストール 
sudp apt install git

プロキシ設定は上記設定ですでに完了しているので git特別の設定は不要


===========================================================
○svnインストール 
sudp apt install subversion

===========================================================
○ctagsインストール 
sudp apt install ctags



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


===========================================================
○ファイルサーバマウント

sudo apt install cifs-utils

sudo vim /etc/fstab

以下の様に記述

//fs-kita3.japan.gds.panasonic.com/sav1$/tech/devcam  /mnt/devcam cifs username=PINナンバー@japan.gds.panasonic.com,password=PASSWORD,sec=ntlm,iocharset=utf8,rw,uid=1000,gid=1000,defaults 0 0





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
一旦自分のホームにインストールしてから /usr/cad 下にコピーする

コピー結果が
/usr/cad/Xilinx_LabTools/14.7 ....
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

usb blaster driver

sudo vim /etc/udev/rules.d/92-usbblaster.rules  (新規作成)
# USB-Blaster
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"

# USB-Blaster II
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"


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








===========================================================
○ xeroxネットプリンタ設定
xeroxのHPからドライバ、とユーティリティ(deb)ファイルをダウンロードして
インストール
　→　残念ながら認証ありの状態で使う方法はわからず






===========================================================
○ 環境整備

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



