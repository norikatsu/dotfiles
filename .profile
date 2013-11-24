#******************************************************************************
#
#  File Name : .profile
#  Type      : Shell init file (for Mingw)
#  Function  : Shell Initial
#
#  This is Mingw Login shell dot file
#   
#   Mingw boot sequence
#     1. exec MSYSroot/bin/sh -login -i
#     2. "sh" load MSYSroot/etc/profile
#     3. "sh" load HOME/.profile (This file)
#     4.   -> HOME/.profile      load HOME/.bash_profile
#     5.   -> HOME/.bash_profile load /etc/bash.bashrc (But nothing is /etc/bash.bashrc at Mingw System....)
#     6.   -> HOME/.bash_profile load HOME/.bashrc
#
#
#   CYGWIM boot sequence
#     1. exec CYGWINroot/bin/bash -login -i
#     2. "bash" load CYGWINroot/etc/profile
#     3. "bash" load HOME/.bash_profile  (This file)
#     4.   -> HOME/.bash_profile load /etc/bash.bashrc
#     5.   -> HOME/.bash_profile load HOME/.bashrc
#
#
#  Author    : Yoshida Norikatsu
#              2010/03/31 Start
#              2010/09/12 Mod for New Mingw(Ver 20100909)
#              2010/09/20 Mod Login sequence
#              2011/05/06 Mod When Shell is bash,Load .bash_profile
#
#******************************************************************************


#******************************************************************************
#  Load .bash_profile when shell is bash (Share Cygwin & Mingw)
#******************************************************************************

# source the users bash_profile if it exists
#if [ -e "${HOME}/.bash_profile" ] ; then
#    source "${HOME}/.bash_profile"
#else
#    echo "No ${HOME}/.bash_profile  (This message at $PWD/.profile)"
#fi



# if running bash
if [ -n "$BASH_VERSION" ]; then 
    # include .bash_profile if it exists
    if [ -f "$HOME/.bash_profile" ]; then
        source "${HOME}/.bash_profile"
    else
        echo "No ${HOME}/.bash_profile  (This message at $PWD/.profile)"
    fi
fi  
