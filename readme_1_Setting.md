# Linux & Windows環境の設定方法
---

## 概要
ドットファイルは OSとして Linux, Cygwin, Mingwで共用とする。  
また家と会社でも共有する。  
全て、gitで管理する管理リポジトリは ```ssh://norikatsu@git.codebreak.com/norikatsu/dotfiles.git ```


### 環境依存ファイルについて
環境依存の切り分けは OSの違いを環境変数 $OSTYPE で切り分ける(OSに標準で設定されている)  
家と会社の環境の違いは個人的に定義した環境変数 $LOCATIONTYPE で切り分ける。  
この変数は 以下のファイルで設定する
```
/etc/profile
```

現時点では MYHOME と OFFICE の二種類
```
1.家庭用の設定
export LOCATIONTYPE=MYHOME

2.会社用の設定
export LOCATIONTYPE=OFFICE
```

### ドットファイルについて
管理しているファイルはドットファイル類と解説テキスト類になる。  
Linux用のファイル構成が基本となっているため、VIMの設定ファイルについては注意が必要（後述）  
会社専用の設定は特にプロキシ関連の設定が必要になる（後述）  


ダウンロード方法 は 以下のコマンドを $HOMEで実行する
```
$ git clone ssh://norikatsu@git.codebreak.com/norikatsu/dotfiles.git 
```

#### VIM設定
##### 設定ファイル
.vimrcと 設定フォルダ .vim/ へのソフトリンクを張る

```
linux
$ ln -s TARGET LINK_NAME

Windows (管理者権限でコンソールを開き実行)
mklink LINK TARGET
```

##### ホームディレクトリを設定
Windowsの環境変数 %HOME% にホームディレクトリを設定する

       2.2.1.2 Windows7での設定
           1. $HOME に移動し DOSにて以下のコマンドを実行

##### VIM プラグイン展開
vimのプラグイン vim/vundle.git は submodule管理している
以下のコマンドを実行する

```
$ cd ~/dotfiles
$ git submodule init
$ git submodule update
```


##### neobundle の設定

Windowsの設定  
環境変数にgitコマンドへのパスを追加  
**プロキシの設定については要確認**



#### X-server について
Windows側からLinuxへ X経由で接続するための設定  
サーバは cygwin版、Xming版二種類あるが、Xming版を用いる  

##### Linux側の設定

XDMCP の設定  
SELinux 設定は Permissive または Disabled とする  
/etc/gdm/custom.conf の編集  
```
[securiry]
AllowRemoteRoot=true
[xdmcp]
Enable=true
```

##### /etc/hosts.allow と /etc/hosts.deny の設定
/etc/hosts.allow にはアクセスを許可するホストを記述  
/etc/hosts.deny にはアクセスを拒否するホストを記述  
hosts.allowが優先される

例えば、 Linuxホスト側で、GNOME環境のgdmが動作していて (＝XDMCP接続を行う)
IPアドレスが 192.168.100.* の範囲にあるホストからのアクセスを許可する 場合には
/etc/hosts.allow を以下のように設定

```
all: 127.0.0.1
gdm: 192.168.100.
```

127.0.0.1 は自分自身へのアクセスを意味している
デーモン名については必要に応じて、XDMCP の場合は、 gdm、 kdm、 xdm、 など、 rexec の場合は in.rexecd と記述します。

以下に実際の設定
```
/etc/hosts.allow
all : 127.0.0.1 [PCのアドレス]

/etc/hosts.deny
gdm:ALL
```



#### Linuxファイアウォールの設定

XDMCP(xdmcp:udp) と Xフォントサーバ(xfs:tcp) のために、ファイアウォールに穴を空ける  
メニューバーから「デスクトップ」→「管理」→「セキュリティレベルとファイヤーウォールの設定」を選択。  
[セキュリティレベル] 画面が表示されて、[ファイアウォールのオプション] タブが選択されている。  
[その他のポート] をクリックすると、ポートの追加領域が表示される。  
[追加] ボタンをクリックして、“xdmcp udp” と “xfs tcp” を登録。  
[OK] ボタンをクリック。  



#### Windows側の設定
##### シングルウィンドウ
Cygwinによる設定を例として記述する
```
"C:\cygwin\bin\XWin.exe -fullscreen -depth 32 -query LinuxPCのIP -from WindowsPCのIP"

"C:\cygwin\bin\XWin.exe -screen 0 1280 800 -query LinuxPCのIP -from WindowsPCのIP"
                        ^^^^^^^^^^^^^^^^^^
"1280 800" が XWinのウィンドウサイズになります。例では 1280x800 のウィンドウが表示される。
```


##### マルチウィンドウ
Xming - XLaunch を実行  
+ .Multiple window  
（number：適当な数字　複数の設定を行う場合は異なる数字を用いる）  
+ start a program  
Start program  
$HOME/start_at_xming.sh を指定  
+ Using PuTTy -> Connect to Computer等の設定は接続先の IP user passを入力  
上記設定を config.xlaunch で保存  

$HOME/start_at_xming.sh を作成  
-> このファイルはすでに リポジトリに登録済み  


#### Samba 設定
ここに記すSambaの設定は CentOS の例である
##### インストール
アプリケーション　-　ソフトウェアの追加と削除をクリック
「パッケージマネージャ」が起動するので、サーバ - Windowsファイルサーバ にチェックを入れ、適応ボタンをクリック

##### 設定
システム - 管理 - サーバ設定 - samba をクリック  
ユーザ登録  
プレファレンス-sambaのユーザをクリック  
ユーザーの追加をクリック  
unixユーザー名から 既存の自分のアカウントを選択  
winsowsユーザー名:上と同じにしておく  
sambaのパスワード：上記のアカウントと同じパスワードにしておく  

##### 共有したいフォルダ (自分のホームなど)追加
ディレクトリ：共有フォルダ  
共有名：Windowsから見えるフォルダ名  
記述  :適当な説明  
アクセス ：アクセス制限 → 特定のユーザーのみのアクセス許可を選び 先ほど作成したユーザーを選択  

##### 設定ファイルの修正
```/etc/samba/smb.conf ``` を編集  
80行目付近の "hosts allow"のコメントアウトを解除し以下(???? 部は自分のマシンのIP)のように修正  
hosts allow = 127.  10.64.221.????  
235行目付近の "map archive"のコメントアウトを解除し以下のように修正  
``` map archive = no```  

##### サービス起動
システム - 管理 - サーバ設定 - サービスをクリック  
バックグラウンドのサービス内から "smb"にチェックを入れ、保存をクリック（これで次回起動時からサービス開始）  

##### ファイアウォール設定
システム - 管理 - セキュリティレベルとファイヤーウォールの設定 をクリック  
ファイアウォールのオプションタブを選択し Sambaにチェックマークを入れ　適応をクリック  



### プリンタ設定 (for Linux)
ここに記すプリンタの設定は CentoOSの例である

#### Canonの例
linux用のドライバ 以下の2つをダウンロード  
"CUPSドライバ共通モジュール"  
"LIPSLX Printer Driver"  

上記2つをインストール（先に CUPSをインストール）  

設定-印刷　から プリンタの追加  
たいていは任意でよい  
「接続の種類」は "AppSocket/HP jetDirect"を選択  
ホスト名には プリンタのIPアドレスを入力　ポートは9100のまま  
デバイス選択で先ほどインストールしたドライバが有効になっていれば LBP3900/3950 が選べるようになっている  

#### EPSONの例
LP9800のドライバは既にインストールされているので、直接プリンタの追加を行えばOK


