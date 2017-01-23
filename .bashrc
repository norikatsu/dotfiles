#******************************************************************************
#
#   File Name   :   .bashrc
#   Type        :   bash init file
#   Function    :   bash Initial
#
#   This is Linux & Cygwim & Mingw Login shell dot file
#
#   Linux GUI loging sequence
#     1. init system.....
#     2. load /etc/bash_profile
#     3. load $HOME/.bash_profile
#     4. load $HOME/.bashrc (This file)
#     5. exec xdm(gdm)  -> Login(GUI)
#     6.   -> load /etc/bashrc
#     7.   -> load $HOME/.bashrc (This file)
#
#
#   Linux CUI loging sequence
#     1. init system.....a
#     2. Login(CUI)
#     3. load /etc/bash_profile
#     4. load $HOME/.bash_profile
#     5. load $HOME/.bashrc (This file)
#
#
#   Mingw boot sequence
#     1. exec MSYSroot/bin/sh -login -i
#     2. "sh" load MSYSroot/etc/profile
#     3. "sh" load HOME/.profile
#     4.   -> HOME/.profile      load HOME/.bash_profile
#     5.   -> HOME/.bash_profile load /etc/bash.bashrc (But nothing is /etc/bash.bashrc at Mingw System....)
#     6.   -> HOME/.bash_profile load HOME/.bashrc (This file)
#
#
#   CYGWIM boot sequence
#     1. exec CYGWINroot/bin/bash -login -i
#     2. "bash" load CYGWINroot/etc/profile
#     3. "bash" load HOME/.bash_profile
#     4.   -> HOME/.bash_profile load /etc/bash.bashrc
#     5.   -> HOME/.bash_profile load HOME/.bashrc (This file)
#
#   Author      :   Yoshida Norikatsu
#               2010/03/31 Start
#               2010/04/01 Marge Mingw Version & Cygwin Version]
#               2010/04/01 Mod for Home PC
#               2010/04/05 Mod PATH
#               2010/09/12 Mod for New Mingw(Ver 20100909)
#               2010/09/20 Mod boot sequence
#               2011/05/09 alias vi -> vim, PROMPT_COMMAND
#               2011/05/11 alias nau -> nautilus --no-desktop
#
#               2011/05/14 Restart (Combine Cygwin,Mingw,Linux Version)
#               2011/05/26 Add Alias for SVN
#               2011/06/03 Undefine C-s (STOP setting)
#               2011/06/14 Add View alias
#               2011/06/19 Mod QuartsuII alias
#               2014/11/17 Mod Docker  alias
#
#******************************************************************************


#******************************************************************************
# For ftp 
#******************************************************************************
[ -z "$PS1" ] && return


#******************************************************************************
# Source global definitions
#******************************************************************************

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

#******************************************************************************
# Check LOCATIONTYPE Variable is undefined
#******************************************************************************

if [ "${LOCATIONTYPE}" == "" ]; then
    echo " LOCATIONTYPE Variable is undefined.  Please define it in /etc/profile"
    echo " This message is sent from ${HOME}/.bashrc"
fi


#******************************************************************************
# Setting Aliases
#******************************************************************************

if ls --color=auto --show-control-chars >/dev/null 2>&1;then
    alias ls='ls --show-control-chars -F --color=auto'
    alias ll='ls --show-control-chars -l -F --color=auto'
else
    alias ls='ls -F --color=auto'
    alias ll='ls -l -F --color=auto'
fi

alias vi='vim'
alias gvi='gvim'

alias sva='svn add'
alias svc='svn ci'
alias svu='svn up'
alias svd='svn diff'
alias svs='svn status'
alias svl='svn log'
alias svm='svn log | more'
alias svz='svn up; svn diff; svn status'

alias ff='firefox'

alias nkfe='nkf -e --overwrite'


alias dpid='docker inspect $(docker ps -q) | awk "/Pid/{print int(\$2)}"' 
alias nconnect='sudo nsenter -t $(dpid) -m -u -i -n -p -- /bin/bash'




case $OSTYPE in
    # ***** Cygwin
    cygwin)
        ;;
    # ***** Mingw
    msys)
        alias vim='gvim'
        ;;
    # ***** Linux
    linux-gnu)
        ;;
esac



#********** MYHOME setting **********
if [ "${LOCATIONTYPE}" == "MYHOME" ]; then

    #========== Filer
    if [ "${OSTYPE}" == "linux-gnu" ]; then
        alias nau='nautilus --no-desktop'
    fi

    #========== GUI Yum Tool
    if [ "${OSTYPE}" == "linux-gnu" ]; then
        alias gyum='/usr/bin/pirut'
    fi


    #========== QuartusII
    if [ "${OSTYPE}" == "linux-gnu" ]; then
        alias qua='quartus'
        alias qprg='quartus_pgmw'
    else
        alias qua='quartus'
        alias qprg='quartus_pgmw'
    fi

#********** OFFICE setting **********
elif [ "${LOCATIONTYPE}" == "OFFICE" ]; then

    #========== Filer
    if [ "${OSTYPE}" == "linux-gnu" ]; then
        alias nau='nautilus --no-desktop'
        alias nem='nemo --no-desktop 2>/dev/null'
    fi

    #========== GUI Yum Tool
    if [ "${OSTYPE}" == "linux-gnu" ]; then
        alias gyum='/usr/bin/pirut'
    fi


    #========== QuartusII
    if [ "${OSTYPE}" == "linux-gnu" ]; then
        alias qua='quartus --64bit'
        alias qua11='/usr/cad/quartus-111/quartus/bin/quartus --64bit'
        alias qprg='quartus_pgmw --64bit'
    else
        alias qua='quartus'
        alias qua11='/usr/cad/quartus-111/quartus/bin/quartus'
        alias qprg='quartus_pgmw'
    fi
#********** Non-Correspondence **********
else
    echo " LOCATIONTYPE Variable is ${LOCATIONTYPE} is non-correspondence.  Please confirm it in /etc/profile"
    echo " This message is sent from ${HOME}/.bashrc"
fi

#******************************************************************************
# Setting Functions
#******************************************************************************

# Some example functions



#******************************************************************************
# Shell Options & Variables
#******************************************************************************

# Set stty (Undefine "STOP" Key assign)
stty stop undef


# Set File Permission
umask 022

#========== Set Prompt ==========
PS1='\[\e[0;32m\][\u@\h\[\e[00m\] \[\e[0;33m\]\w\[\e[00m\]\[\e[0;32m\]]\[\e[00m\] \$ '

if [ "${TERM}" == "screen" ]; then
    export PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\033\\"; echo -ne "\ek\e\\"'
fi


#========== Python 2 or 3 selectable ==========
#export WORKON_HOME=~/.virtualenvs
#source `which virtualenvwrapper.sh`



#========== SSH remote No Error ==========
export NO_AT_BRIDGE=1


#========== fcitx ==========
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export DefaultIMModule=fcitx



