#!/usr/bin/bash
#******************************************************************************
#
#  File Name :  start_at_MobaXterm.sh
#  Type      :  bash shell script file
#  Function  :  MobaXtermから ログインしたときに fcitxを使える用にするためのスクリプト
#               このスクリプトは MobaXtermから実行される
#  Author    :  Yoshida Norikatsu
#               2016/12/24 Start
#               2017/01/03 Mod byobu Version
#******************************************************************************

source /etc/profile
source ~/.bash_profile

fcitx -d 2>/dev/null

#if [ "${LOCATIONTYPE}" == "MYHOME" ]; then
#    gnome-terminal --zoom=1.0 --command='screen -D -RR'
#elif [ "${LOCATIONTYPE}" == "OFFICE" ]; then
#    gnome-terminal --zoom=1.0 --command='screen -D -RR'
#else
#    gnome-terminal --zoom=1.0 --command='screen -D -RR'
#fi

if [ "${LOCATIONTYPE}" == "MYHOME" ]; then
    gnome-terminal --zoom=1.0 --command='byobu'
elif [ "${LOCATIONTYPE}" == "OFFICE" ]; then
    gnome-terminal --zoom=1.0 --command='byobu'
else
    gnome-terminal --zoom=1.0 --command='byobu'
fi

