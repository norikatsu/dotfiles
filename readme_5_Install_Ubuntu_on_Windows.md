

1. gnome-terminal インストール
    sudo apt-get install aptitude
    sudo aptitude install gnome-terminal


2.日本語入力ができるよう インストール
    sudo apt install fonts-ipafont
    sudo apt install uim uim-xim uim-anthy


3. 環境変数設定
    export DISPLAY=localhost:0.0
    export XMODIFIERS="@im=uim"
    export GTK_IM_MODULE=uim 
    export QT_IM_MODULE=uim


で書いたかな漢字変換サーバとlxterminalの起動を自動化するなら、例えばhome directoryの.bashrcの末尾に
if [ $SHLVL -eq 1 ]; then
  if DISPLAY=localhost:0.0 xset q > /dev/null 2>&1 ; then
    DISPLAY=localhost:0.0 UIM_CANDWIN_PROG=uim-candwin-gtk uim-xim &
    DISPLAY=localhost:0.0 XMODIFIERS="@im=uim" GTK_IM_MODULE=uim QT_IM_MODULE=uim lxterminal &
  fi
fi
のように書けばいいでしょう。最初に起動されたbashで、なおかつXが利用可能なら、かな漢字変換サーバとlxterminalを起動します。
