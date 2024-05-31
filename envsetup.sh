#!/bin/bash

#
# envsetup.sh for buildroot-sbc
#


LOCAL_COMMIT_ID=$(git rev-parse --short HEAD)          
export SOURCE_PATH=$(pwd)
export BR2_PATH=$SOURCE_PATH/buildroot

echo " _____ _____ ___    _____ _____ _____ "
echo "| __  | __  |_  |  |   __| __  |     |"
echo "| __ -|    -|  _|  |__   | __ -|   --|"
echo "|_____|__|__|___|  |_____|_____|_____|"
echo -e "Commit:      $LOCAL_COMMIT_ID\n"

# WSL SUpport
if [ $(uname -r | grep -c "WSL1") -eq 1 ];
then
    # Not support WSL 1
    echo "#### Buildroot-SBC Not Support WSL 1 ####"
    exit 1
elif [ $(uname -r | grep -c "WSL2") -eq 1 ];
then
    echo "Buildroot-SBC Now running on WSL2, setting PATH..."
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib"
fi

UpdateInfo(){
    echo "************************************************************"
    echo "* Update done! You may need to run sync_update after lunch.*"
    echo "************************************************************"
}

FetchUpdate(){
    git fetch origin master:tmp
    if [ $(git diff tmp | grep -c "-") -gt 1 ];
    then
        read -r -p "Update found, Update to Remote? [y/N] " input
        case $input in
            [yY][eE][sS]|[yY])
                echo "Now try to merge upstream..."
                git merge tmp
                UpdateInfo
                ;;
        
            [nN][oO]|[nN])
                echo "Cancel update..."         
                ;;
        
            *)
                echo "Invalid input..."
                ;;
        esac
    else
        echo "Local code all up to date! commit id:" 
        git rev-parse HEAD
    fi
    # delete the commit
    git branch -d tmp
}

# Fetch latest commit.

read -r -p "Check for repository updates ?[y/N] " input
case $input in
    [yY][eE][sS]|[yY])
        echo "Fetching remote repo data..."
        FetchUpdate
        ;;
    
    [nN][oO]|[nN])
        echo "Cancel update check..."        
        ;;
    *)
        echo "Cancel update check..."
        ;;
esac

# configure C compiler
export compiler=$(which gcc)
 
# get version code
MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -xc - | tail -n 1)

if [ $MAJOR -lt 7 ];
then 
    echo "#### Buildroot-SBC Not Support GCC Version less than 7 ####"
elif [ $MAJOR -gt 12 ];
then
    echo "#### Buildroot-SBC Not Support GCC Version more than 12 ####"
else
    echo "Your Host GCC Version is $MAJOR.$MINOR.$PATCHLEVEL"
fi

# Add alias 

# Alias
alias lunch="cd buildroot && echo -e \"You're building on Linux\n\nLunch menu... \npick a combo by 'make xxx_defconfig':\nScaning combo...\" && make list-defconfigs"
alias lunchs="cd buildroot"
alias rebuild_kernel="touch ./output/images/a.dtb && rm ./output/images/*.dtb && make linux-rebuild -j8 && make"
alias rebuild_uboot="make uboot-rebuild -j8 && make"
alias wsl_path="export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib\""
alias sync_kernel="rm -rf output/build/linux* && rm -rf output/build/.linux* && make"
alias sync_uboot="rm -rf output/build/uboot* && make"
alias sync_update="rm -rf output/build/linux* && rm -rf output/build/.linux* && rm -rf output/build/uboot* && rm -rf dl/uboot* && rm -rf dl/linux*"

alias mm="make"
alias m="make"
alias mkernel="rebuild_kernel"
alias rkernel="rebuild_kernel"

alias sm="make savedefconfig"
alias skernel="make linux-update-defconfig"
alias suboot="make uboot-update-defconfig"

alias muboot="rebuild_uboot"
alias ruboot="rebuild_uboot"
alias mboot="rebuild_uboot"

# For develop
alias croot="cd $BR2_PATH"
alias cconfig="cd $BR2_PATH/configs"
alias cout="cd $BR2_PATH/output"
alias cplat="cd $BR2_PATH/board"

LOCAL_COMMIT_ID=$(git rev-parse --short HEAD)

echo -e "\n"
echo "******************************************"
echo "* Setup env done! Please run lunch next. *"
echo "******************************************"
