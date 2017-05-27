#!/bin/bash

# Ubuntu on Windows環境でかな漢字変換サーバとterminal起動を自動化
if [ $SHLVL -eq 2 ] ; then
	DISPLAY=localhost:0.0 UIM_CANDWIN_PROG=uim-candwin-gtk uim-xim &
	DISPLAY=localhost:0.0 XMODIFIERS="@im=uim" GTK_IM_MODULE=uim QT_IM_MODULE=uim gnome-terminal &
fi
