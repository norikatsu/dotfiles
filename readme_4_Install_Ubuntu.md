
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
ln -s ./dotfiles/.bash_profile .bash_profile
ln -s ./dotfiles/.profile .profile
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
○ xeroxネットプリンタ設定
xeroxのHPからドライバ(deb)ファイルをダウンロードして
インストール

GUIのシステム - プリンタから追加 (ネット、プロトコルは IPP)











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



