#!/bin/bash
set -e
function sethostname() {
        local GetEC2InstanceID=`curl http://169.254.169.254/latest/meta-data/instance-id`
        local GetEC2InstanceTag=`aws ec2 describe-tags --region ap-southeast-1 --filters "Name=resource-id,Values=$GetEC2InstanceID" --query "Tags[?Key=='Name']" | grep Value | tr -d ' ' | cut -f2 -d: | tr -d '"' | tail -1 `
        sudo /usr/bin/hostnamectl set-hostname $GetEC2InstanceTag
}

function aptupdate() {
        sudo apt update
        sudo apt remove vim -y
        sudo apt upgrade -y
        sudo apt install gpg unzip net-tools chrony htop neovim apt-transport-https -y
        sudo apt autoremove -y
}

function settimezone() {
        sudo /usr/bin/timedatectl set-timezone 'Asia/Kuala_Lumpur'
}

function updateprofile() {
        local paths="~/.bashrc"
        local checkPS=`grep PS1 $paths | grep -v '#'`
        local checkLS=`grep "alias ls=" $paths | grep -v '#'`
        local checkLL=`grep "alias ll=" $paths | grep -v '#'`
        local checkL=`grep "alias l=" $paths | grep -v '#'`
        local checkRM=`grep "alias rm=" $paths | grep -v '#'`
        local checkCP=`grep "alias cp=" $paths | grep -v '#'`
        local checkMV=`grep "alias mv=" $paths | grep -v '#'`
        local checkGREP=`grep "alias grep=" $paths | grep -v '#'`
        if [ ! -z $checkPS ]; then
            echo "Insert PS1"
            echo "PS1='${debian_chroot:+($debian_chroot)}\u@\[\e[1;32m\]\h\[\e[m\]:\w\$ '" | tee -a ~/.bashrc
        fi
        if [ ! -z $checkLS ]; then
            echo "Insert LS"
            echo "alias ls='ls --color=always --group-directories-first'" | tee -a ~/.bashrc
        fi
        if [ ! -z $checkLL ]; then
            echo "Insert LL"
            echo "alias ll='ls -lah --color=always --group-directories-first'" | tee -a ~/.bashrc
        fi
        if [ ! -z $checkL ]; then
            echo "Insert L"
            echo "alias l='ls -lA --color=always --group-directories-first'" | tee -a ~/.bashrc
        fi
        if [ ! -z $checkRM ]; then
            echo "Insert RM"
            echo "alias rm='rm -i" | tee -a ~/.bashrc
        fi
        if [ ! -z $checkCP ]; then
            echo "Insert CP"
            echo "alias cp='cp -i" | tee -a ~/.bashrc
        fi
        if [ ! -z $checkMV ]; then
            echo "Insert MV"
            echo "alias mv='mv -i" | tee -a ~/.bashrc
        fi
        if [ ! -z $checkGREP ]; then
            echo "Insert GREP"
            echo "alias grep='grep --color=auto" | tee -a ~/.bashrc
        fi        
}
echo "Setup Hostname"
sethostname
echo "Setup Timezone"
settimezone
echo "APT update"
aptupdate
