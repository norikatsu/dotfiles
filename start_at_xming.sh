#!/bin/bash
#******************************************************************************
#
#  File Name :  start_at_xming.sh
#  Type      :  bash shell script file
#  Function  :  Xmingから ログインしたときに SCIMを使える用にするためのスクリプト
#               このスクリプトは Xming(putty)から実行される
#  Author    :  Yoshida Norikatsu
#               2011/05/10 Start
#               2011/05/11 Add Zoom option & Command Option
#               2011/05/14 Add source /etc/profile
#               2011/05/17 Mod MYHOME setting
#               2011/05/18 Mod Bug (Comment Only)
#******************************************************************************

source /etc/profile
source ~/.bash_profile

export GTK_IM_MODULE="scim-bridge"
scim -d

if [ "${LOCATIONTYPE}" == "MYHOME" ]; then
    gnome-terminal --zoom=1.4 --command='screen -D -RR'
elif [ "${LOCATIONTYPE}" == "OFFICE" ]; then
    gnome-terminal --zoom=1.2 --command='screen -D -RR'
else
    gnome-terminal --zoom=1.2 --command='screen -D -RR'
fi

