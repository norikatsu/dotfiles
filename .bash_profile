#******************************************************************************
#
#   File Name   :   .bash_profile
#   Type        :   bash init file
#   Function    :   bash Initial
#
#  This is Linux & Cygwim & Mingw Login shell dot file
#
#   Linux GUI loging sequence
#     1. init system.....
#     2. exec xdm(gdm)  -> Login(GUI)
#     3. load /etc/profile
#     4. load $HOME/.bash_profile
#     5.   -> load $HOME/.bashrc
#     6.   -> load /etc/bashrc
#     7. Exe bash (terminal)
#     8.   -> load $HOME/.bashrc
#     9.   -> load /etc/bashrc
#
#   Linux CUI loging sequence
#     1. init system.....a
#     2. Login(CUI)
#     3. load /etc/profile
#     4. load $HOME/.bash_profile
#     5.   -> load $HOME/.bashrc
#     6.   -> load /etc/bashrc
#
#
#   Mingw boot sequence
#     1. exec MSYSroot/bin/sh -login -i
#     2. "sh" load MSYSroot/etc/profile
#     3. "sh" load HOME/.profile
#     4.   -> HOME/.profile      load HOME/.bash_profile (This file)
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
#   Author      :   Yoshida Norikatsu
#               2010/03/31 Start
#               2010/09/20 Mod Environment Variables
#               2011/04/25 Add EXEC SCREEN
#               2011/05/05 Mod PATH
#               2011/05/07 Separate Common-file and Local-file
#               2011/05/09 Mod SVN_EDITOR , EDITOR
#
#               2011/05/14 Restart (Combine Cygwin,Mingw,Linux Version)
#               2011/05/25 Add JuliaLsi Path setting
#               2011/06/08 Add Vim Backup Files Dir Setting
#               2014/11/19 Add Vertual Box PATH 
#               2014/11/23 Add Python PATH 
#               2017/05/18 Mod Questa(Modelsim) Path & License
#
#******************************************************************************


#******************************************************************************
# Source the system wide bashrc if it exists (Cygwin only....)
#******************************************************************************

#if [ -e /etc/bash.bashrc ] ; then
#  source /etc/bash.bashrc
#fi



#******************************************************************************
# Source the users bashrc if it exists
#******************************************************************************

if [ -e "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
else
  echo "No ${HOME}/.bash  (This message at ${HOME}/.bash_profile)"
fi



#****************************************************************************o*
# Make Need Files & Dir
#******************************************************************************

#---------- Make Tmp Dir
if [ ! -d "${HOME}/tmp" ] ; then
    mkdir ${HOME}/tmp
fi

#---------- Make VIM Backup Files Dir
if [ ! -d "${HOME}/tmp/vimbackup" ] ; then
    mkdir ${HOME}/tmp/vimbackup
fi




#****************************************************************************o*
# Delete Environment Variables
#******************************************************************************

#========== Delete ( Windows Environment Variables )
unset LM_LICENSE_FILE




#****************************************************************************o*
# Setting Variable of Environmental Dependence Type
#   Use $OSTYPE & $LOCATIONTYPE
#
#       LOCATIONTYPE that is a personal variable is defined in /etc/profile.
#******************************************************************************

#********** LOCATIONTYPE Variable is undefined **********
if [ "${LOCATIONTYPE}" == "" ]; then
    echo " LOCATIONTYPE Variable is undefined.  Please define it in /etc/profile"
    echo " This message is sent from ${HOME}/.bash_profile"

    #   TMP                 # for cygwin
    #   TEMP                # for cygwin
    #   VIMRUNTIME          # for mingw
    export QUARTUS_ROOTDIR=undefined
    export QUARTUS_LICENSE=undefined
    export ALTLIB_BASEPATH=undefined
    export MODEL_TECH_BASE_PATH=undefined
    export MODELSIM_PATH=undefined
    export MODELSIM_LICENSE=undefined


#********** MYHOME setting **********
elif [ "${LOCATIONTYPE}" == "MYHOME" ]; then

    #========== Set Tmp (cygwin only)
    if [ "${OSTYPE}" == "cygwin" ]; then
        export TMP=/tmp
        export TEMP=/tmp
    fi

    #========== Set VIM runtime path (mingw only)
    #if [ "${OSTYPE}" == "msys" ]; then
    #    export VIMRUNTIME=/share/vim/vim73
    #fi


    unset VIM_PATH
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export VIM_PATH=/cygdrive/c/ProgramFiles/vim
            ;;
        # ***** Mingw
        msys)
            export VIM_PATH=/c/ProgramFiles/vim
            ;;
        # ***** Linux
        linux-gnu)
            export VIM_PATH=/usr/local/bin
            ;;
    esac


    #========== Set Git Path
    #case $OSTYPE in
    #    # ***** Cygwin
    #    cygwin)
    #        export GIT_PATH=
    #        ;;
    #    # ***** Mingw
    #    msys)
    #        export GIT_PATH=/mingw/Git/bin
    #        ;;
    #    # ***** Linux
    #    linux-gnu)
    #        export GIT_PATH=
    #        ;;
    #esac


    #========== Set VertualBox Path
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export VBOX_PATH="/cygdrive/c/Program Files/Oracle/VirtualBox"
            ;;
        # ***** Mingw
        msys)
            export VBOX_PATH="/c/Program Files/Oracle/VirtualBox"
            ;;
        # ***** Linux
        linux-gnu)
            export VBOX_PATH=
            ;;
    esac

    #========== Set Python Path
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export PYTHON_PATH=
            ;;
        # ***** Mingw
        msys)
            export PYTHON_PATH="/c/Python34"
            ;;
        # ***** Linux
        linux-gnu)
            export PYTHON_PATH=
            ;;
    esac

    #========== Set Altera QuartusII Path & Lincense
    export QUARTUS_LICENSE=nothing

    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export QUARTUS_ROOTDIR=/cygdrive/c/altera/13.1/quartus
            ;;
        # ***** Mingw
        msys)
            export QUARTUS_ROOTDIR=/c/altera/13.1/quartus
            ;;
        # ***** Linux
        linux-gnu)
            export QUARTUS_ROOTDIR=/usr/cad/quartus-110/quartus
            ;;
    esac

    #========== Set Altera Simulation Library Path for Modelsim
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export ALTLIBPATH=C:/altera/13.1/modelsim_ase/altera/verilog
            ;;
        # ***** Mingw
        msys)
            export ALTLIBPATH=/c/altera/13.1/modelsim_ase/altera/verilog
            ;;
        # ***** Linux
        linux-gnu)
            export ALTLIBPATH=/usr/cad/modelsim-110/modelsim_ase/altera/verilog
            ;;
    esac

    #========== Set ModelSim Path & Lincense
    export MODELSIM_LICENSE=nothing

    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export MODEL_TECH=/cygdrive/c/altera/13.1/modelsim_ase
            export MODELSIM_PATH=${MODEL_TECH}/win32aloem
            ;;
        # ***** Mingw
        msys)
            export MODEL_TECH=/c/altera/13.1/modelsim_ase
            export MODELSIM_PATH=${MODEL_TECH}/win32aloem
            ;;
        # ***** Linux
        linux-gnu)
            export MODEL_TECH=/usr/cad/modelsim-110/modelsim_ase
            export MODELSIM_PATH=$MODEL_TECH/bin
            # 32bit or 64bit
            export MTI_VCO_MODE=32
            #export MTI_VCO_MODE=64
            export MTI_GCC_VER=4.3.3
            ;;
    esac

    #========== Set Sourcery CodeBench
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export CODEBENCHPATH=/cygdrive/c/MinGW/msys/1.0/opt/MentorGraphics/Sourcery_CodeBench_Lite_for_ARM_GNU_Linux/bin
            ;;
        # ***** Mingw
        msys)
            export CODEBENCHPATH=/opt/MentorGraphics/Sourcery_CodeBench_Lite_for_ARM_GNU_Linux/bin
            ;;
        # ***** Linux
        linux-gnu)
            export CODEBENCHPATH=/opt/MentorGraphics/Sourcery_CodeBench_Lite_for_ARM_GNU_Linux/bin
            ;;
    esac

    #========== Set Leda
    export SYNOPSYS_LICENSE=nothing
    export LEDA_PATH=/usr/local
    export LEDA_CONFIG=nothing

    #========== Set Xilinx
    export XILINXD_LICENSE_FILE=2100@10.64.218.165
    export VIVADO=/usr/cad/vivado-2013.3/Vivado/2013.3

    export XILINX_LIB_PATH=/usr/local/Xilinx_LabTools/14.7/LabTools/LabTools/bin/lin64
    export XIL_IMPACT_USE_LIBUSB=1


    #========== Set Julia Project
    export SVN_JULIA=https://133.181.137.151/julia/repos/julialsi/trunk/julia
    export LSI_HOME=~/julia
    export FPGA_HOME=~/fuji

#********** OFFICE setting **********
elif [ "${LOCATIONTYPE}" == "OFFICE" ]; then

    #========== Set Tmp (cygwin only)
    if [ "${OSTYPE}" == "cygwin" ]; then
        export TMP=/tmp
        export TEMP=/tmp
    fi

    #========== Set VIM runtime path (mingw only)
    #if [ "${OSTYPE}" == "msys" ]; then
    #    export VIMRUNTIME=/share/vim/vim73
    #fi

    unset VIM_PATH
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export VIM_PATH=/cygdrive/c/ProgramFiles/vim
            ;;
        # ***** Mingw
        msys)
            export VIM_PATH=/c/ProgramFiles/vim
            ;;
        # ***** Linux
        linux-gnu)
            export VIM_PATH=/usr/local/bin
            ;;
    esac


    #========== Set Git Path
    #case $OSTYPE in
    #    # ***** Cygwin
    #    cygwin)
    #        export GIT_PATH=
    #        ;;
    #    # ***** Mingw
    #    msys)
    #        export GIT_PATH=/mingw/Git/bin
    #        ;;
    #    # ***** Linux
    #    linux-gnu)
    #        export GIT_PATH=
    #        ;;
    #esac

    #========== Set VertualBox Path
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export VBOX_PATH="/cygdrive/c/Program Files/Oracle/VirtualBox"
            ;;
        # ***** Mingw
        msys)
            export VBOX_PATH="/c/Program Files/Oracle/VirtualBox"
            ;;
        # ***** Linux
        linux-gnu)
            export VBOX_PATH=
            ;;
    esac

    #========== Set Python Path
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export PYTHON_PATH=
            ;;
        # ***** Mingw
        msys)
            export PYTHON_PATH="/c/Python34"
            ;;
        # ***** Linux
        linux-gnu)
            export PYTHON_PATH=
            ;;
    esac

    #========== Set Proxy (Linux only)
    # http ftp proxy
    export http_proxy=http://proxy.mei.co.jp:8080/
    export https_proxy=http://proxy.mei.co.jp:8080/
    export ftp_proxy=http://proxy.mei.co.jp:8080/

    # Git Proxy
    export GIT_PROXY_COMMAND=/usr/local/bin/git-proxy


    if [ "${OSTYPE}" == "linux-gnu" ]; then
        # Wget Proxy
        ln -fs ${HOME}/.wgetrc_office_linux ${HOME}/.wgetrc

        # Mercuria Proxy
        ln -fs ${HOME}/.hgrc_office_linux ${HOME}/.hgrc

    fi


    #========== Set Altera QuartusII Path & Lincense
    export QUARTUS_LICENSE=1700@10.78.91.137

    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export QUARTUS_ROOTDIR=/cygdrive/c/altera/13.1/quartus
            ;;
        # ***** Mingw
        msys)
            export QUARTUS_ROOTDIR=/c/altera/13.1/quartus
            ;;
        # ***** Linux
        linux-gnu)
            #export QUARTUS_ROOTDIR=/usr/cad/quartus-100/quartus
            export QUARTUS_ROOTDIR=/usr/cad/quartus-131/quartus
            #export QUARTUS_ROOTDIR=/usr/cad/quartus-130/quartus

            # QuartusII Auto Add Setting
            export ALTERAOCLSDKROOT="/usr/cad/quartus-161/hld"
            ;;
    esac

    #========== Set Altera Simulation Library Path for Modelsim
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export ALTLIBPATH=C:/altera/10.0sp1/modelsim_ase/altera/verilog
            ;;
        # ***** Mingw
        msys)
            export ALTLIBPATH=/c/altera/10.0sp1/modelsim_ase/altera/verilog
            ;;
        # ***** Linux
        linux-gnu)
            export ALTLIBPATH=/usr/local/altera/modelsim_ase-100sp1/modelsim_ase/altera/verilog
            ;;
    esac

    #========== Set ModelSim Path & Lincense
    #export MODELSIM_LICENSE=1717@132.182.83.174
    #export MODELSIM_LICENSE=1717@cae-x4:1717@zion:1717@jp0200swtc103
    #export MODELSIM_LICENSE=1717@cae-x8:1717@jp0200swtc103
    #export MODELSIM_LICENSE=1717@132.182.83.178
    export MODELSIM_LICENSE=20010@10.186.125.38

    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export MODEL_TECH=/cygdrive/c/modeltech_6.6b
            export MODELSIM_PATH=${MODEL_TECH}/win32
            ;;
        # ***** Mingw
        msys)
            export MODEL_TECH=/c/modeltech_6.6b
            export MODELSIM_PATH=${MODEL_TECH}/win32
            ;;
        # ***** Linux
        linux-gnu)
            export MODEL_TECH=/usr/cad/questa-10.6a/questasim
            export MODELSIM_PATH=$MODEL_TECH/bin
            # 32bit or 64bit
            export MTI_VCO_MODE=32
            #export MTI_VCO_MODE=64
            export MTI_GCC_VER=4.3.3
            ;;
    esac

    #========== Set Sourcery CodeBench
    case $OSTYPE in
        # ***** Cygwin
        cygwin)
            export CODEBENCHPATH=/cygdrive/c/MinGW/msys/1.0/opt/MentorGraphics/Sourcery_CodeBench_Lite_for_ARM_GNU_Linux/bin
            ;;
        # ***** Mingw
        msys)
            export CODEBENCHPATH=/opt/MentorGraphics/Sourcery_CodeBench_Lite_for_ARM_GNU_Linux/bin
            ;;
        # ***** Linux
        linux-gnu)
            export CODEBENCHPATH=/opt/MentorGraphics/Sourcery_CodeBench_Lite_for_ARM_GNU_Linux/bin
            ;;
    esac

    #========== Set Leda
    export SYNOPSYS_LICENSE=27020@132.182.83.177
    case $OSTYPE in
        # ***** Linux
        linux-gnu)
            export LEDA_PATH=/usr/cad/leda-2014.12-SP1-1
            export LEDA_CONFIG=${LEDA_PATH}/pana/leda_config.tcl
            ;;
        # ***** other
        *)
            export LEDA_PATH=/usr/local
            export LEDA_CONFIG=nothing
            ;;
    esac


    #========== Set Xilinx
    export XILINXD_LICENSE_FILE=2100@10.78.91.137
    export VIVADO_PATH=/usr/cad/vivado-2017.2/Vivado/2017.2

    export XILINX_LIB_PATH=/usr/local/Xilinx_LabTools/14.7/LabTools/LabTools/bin/lin64
    export XIL_IMPACT_USE_LIBUSB=1



    #========== Set Julia Project
    export SVN_JULIA=https://133.181.137.151/julia/repos/julialsi/trunk/julia
    export LSI_HOME=~/julia
    export FPGA_HOME=~/fuji


#********** Non-Correspondence **********
else
    echo " LOCATIONTYPE Variable is ${LOCATIONTYPE} is non-correspondence.  Please confirm it in /etc/profile"
    echo " This message is sent from ${HOME}/.bash_profile"
fi




#********** MYHOME & OFFICE setting **********
    #========== Set Lattice Diamond & Lincense
    export DIAMOND_LICENSE=/usr/cad/diamond38/diamond/3.8_x64/license/license.dat

    #========== WINE 32bit Set
    export WINEARCH=win32


#****************************************************************************o*
# Setting Environment Variables
#******************************************************************************

#========== Set LANG
export LANG=ja_JP.UTF-8


#========== Set Editer
export EDITOR=vim


#========== Set SVN Editer
export SVN_EDITOR=vim


#========== Set Julia Script setting
export USERMAIL="Yoshida Norikatsu <yoshida.norikatsu@jp.panasonic.com>"




#========== Set Base Path

#---------- Set Use Binpath
if [ -d "${HOME}/bin" ] ; then
    if [ ! "$(echo $PATH | grep ${HOME}/bin)" ]; then
        export PATH=${PATH}:${HOME}/bin
    fi
fi


#---------- Set Git Binpath
#if [ -d "${GIT_PATH}" ] ; then
#    if [ ! "$(echo $PATH | grep ${GIT_PATH})" ]; then
#        export PATH=${PATH}:${GIT_PATH}
#    fi
#fi


#---------- Set Altera QuartusII Path 

case $OSTYPE in
    # ***** Cygwin
    cygwin)
        if [ ! "$(echo $PATH | grep $QUARTUS_ROOTDIR/bin64)" ]; then
            export PATH=$PATH:$QUARTUS_ROOTDIR/bin64
        fi
        ;;
    # ***** Mingw
    msys)
        if [ ! "$(echo $PATH | grep $QUARTUS_ROOTDIR/bin64)" ]; then
            export PATH=$PATH:$QUARTUS_ROOTDIR/bin64
        fi
        ;;
    # ***** Linux
    linux-gnu)
        if [ ! "$(echo $PATH | grep $QUARTUS_ROOTDIR/bin)" ]; then
            export PATH=$PATH:$QUARTUS_ROOTDIR/bin
        fi
        ;;
esac



#----------  Set ModelSim  Environment Variables 
if [ ! "$(echo $PATH | grep $MODELSIM_PATH)" ]; then
    export PATH=$PATH:$MODELSIM_PATH
fi

#----------  Set LEDA  Environment Variables 
if [ ! "$(echo $PATH | grep ${LEDA_PATH}/bin)" ]; then
    export PATH=$PATH:${LEDA_PATH}/bin
fi


#----------  Set Vivado Environment Variables 
if [ ! "$(echo $PATH | grep ${VIVADO_PATH}/bin)" ]; then
    export PATH=$PATH:${VIVADO_PATH}/bin
    export LD_LIBRARY_PATH=${VIVADO_PATH}/bin:/usr/X11R6/lib:/usr/cad/libs
fi

#----------  Set Xilinx lib tool Environment Variables 
if [ ! "$(echo $PATH | grep ${XILINX_LIB_PATH})" ]; then
    export PATH=$PATH:${XILINX_LIB_PATH}
fi


#----------  Set Julia Project  Environment Variables 
if [ ! "$(echo $PATH | grep ${LSI_HOME}/bin)" ]; then
    export PATH=$PATH:${LSI_HOME}/bin
fi

if [ ! "$(echo $PATH | grep ${FPGA_HOME}/bin)" ]; then
    export PATH=$PATH:${FPGA_HOME}/bin
fi

#----------  Set VIM path setting
if [ ! "$(echo $PATH | grep ${VIM_PATH})" ]; then
    export PATH=${VIM_PATH}:$PATH
fi

#----------  Set VertualBox path setting
if [ ! "$(echo $PATH | grep "${VBOX_PATH}")" ]; then
    export PATH=${VBOX_PATH}:$PATH
fi


#----------  Set Python path setting
if [ ! "$(echo $PATH | grep "${PYTHON_PATH}")" ]; then
    export PATH=${PYTHON_PATH}:$PATH
fi

#----------  Set Source CodeBench path setting
if [ ! "$(echo $PATH | grep "${CODEBENCHPATH}")" ]; then
    export PATH=$PATH:${CODEBENCHPATH}
fi


#---------- Set Current Path
export PATH=$PATH:.



#========== Set License


#---------- Set Altera QuartusII License
if [ ! "$(echo $LM_LICENSE_FILE | grep $QUARTUS_LICENSE)" ]; then
    if [ "$LM_LICENSE_FILE" = "" ]; then
        export LM_LICENSE_FILE=$QUARTUS_LICENSE
    else
        export LM_LICENSE_FILE=$LM_LICENSE_FILE:$QUARTUS_LICENSE
    fi
fi


#---------- Set ModelSim License 
if [ ! "$(echo $LM_LICENSE_FILE | grep $MODELSIM_LICENSE)" ]; then
    export LM_LICENSE_FILE=$LM_LICENSE_FILE:$MODELSIM_LICENSE
fi


#---------- Set Synopsys License 
if [ ! "$(echo $LM_LICENSE_FILE | grep $SYNOPSYS_LICENSE)" ]; then
    export LM_LICENSE_FILE=$LM_LICENSE_FILE:$SYNOPSYS_LICENSE
fi


#---------- Set Lattice Diamond License
if [ ! "$(echo $LM_LICENSE_FILE | grep $DIAMOND_LICENSE)" ]; then
    if [ "$LM_LICENSE_FILE" = "" ]; then
        export LM_LICENSE_FILE=$DIAMOND_LICENSE
    else
        export LM_LICENSE_FILE=$LM_LICENSE_FILE:$DIAMOND_LICENSE
    fi
fi

#****************************************************************************o*
# EXEC Screen
#******************************************************************************

#========== Check Screen
if [ "${OSTYPE}" == "linux-gnu" ]; then
    which screen 1>/dev/null 2>/dev/null
else
    which screen 1>${HOME}/null 2>${HOME}/null
fi

if [ $? -eq 0 ]; then
    SCREEN_ERROR=0
else
    SCREEN_ERROR=1
fi

if [ -e "${HOME}/null" ] ; then
  rm -f ${HOME}/null
fi

#========== Exec screen
if [ "${OSTYPE}" == "linux-gnu" ]; then
    if [ ${SCREEN_ERROR} == "0" ]; then
        if [ "${DISPLAY}" = "" ]; then
            if [ "${TERM}" != "screen" ]; then
                exec screen -D -RR
            fi
        fi
    fi
fi



export QSYS_ROOTDIR="/usr/cad/quartus-161/quartus/sopc_builder/bin"
