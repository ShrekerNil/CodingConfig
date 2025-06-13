#!/bin/sh  
#============ get the file name ===========

function show_green() {
    content=$1
    # echo -e "\033[32m$content\033[0m"
    echo -e "\033[42;37m$content\033[0m"
}

function show_red() {
    content=$1
    # echo -e "\033[31m$content\033[0m"
    echo -e "\033[41;37m$content\033[0m"
}

function new_line() {
    echo -e "\n"
}

# cur_dir="$( cd "$( dirname "$0"  )" && pwd )"
cur_dir="/d/QLRepo"

show_green "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
show_green "Start Removing Cache From Root Directory: $cur_dir            +"
show_green "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

function start_process() {
    cur_dir=$1
    for sub_dir in ${cur_dir}/*; do
        if test -d $sub_dir ; then
            cd $sub_dir
            show_green ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            new_line
            show_green "Found Sub Directory: `basename $sub_dir`"
            if [[ -d "${sub_dir}/.git" && -f "${sub_dir}/mine" ]]; then
                git rm -r --cached ./
                echo Synchronizing AUTO Git Repo: $sub_dir
                bash /d/QLRepo/QLConfig/Linux/Scripts/GitScripts/git-sync.sh `pwd`
                continue
            else
                echo "This is Not a Git Repo or not mine found, Handling Sub Directory ..."
                start_process $sub_dir
            fi
            new_line
        fi
    done
}

start_process $cur_dir

show_green "~~~~~~~~~~~~~~~~~~~~~~~~~~~ All Work Done! ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
new_line
read -p "Pressing Enter To Exit ... "
