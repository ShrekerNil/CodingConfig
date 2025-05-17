#!/bin/sh
#============ get the file name ===========

echo_success() {
    echo -e "\033[32m$1\033[0m"
}

echo_failure() {
    echo -e "\033[41;37m$1\033[0m"
}

echo_warning() {
    echo -e "\033[43;37m$1\033[0m"
}

echo_separator() {
    echo -e "\033[44;37m$1\033[0m"
}

echo_info() {
    echo -e "\033[40;37m$1\033[0m"
}

new_line() {
    echo -e "\n"
}

echo_git_tree() {
    echo "$1" >> test.txt
}

start_process() {
    cur_dir=$1
    echo_separator "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo_info "Start Synchronizing Root: ${cur_dir}"
    echo_separator "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    echo_git_tree "${cur_dir}"

    for sub_dir in "${cur_dir}"/*; do
        if test -d "${sub_dir}"; then
            cd "${sub_dir}" || exit
            new_line
            echo_separator ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            echo_info "         Found Sub Dir: $(basename "${sub_dir}")"
            echo_separator "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            if [[ -d "${sub_dir}/.git" ]]; then

                ori=$(git remote -v)
                echo ori:"$ori"
                result=${ori#*in}
                result=${result%% *}
                echo res:"$result"
#                echo_git_tree "$result"

                if [[ -f "mine" ]]; then
                    new_line
                    echo_info "Synchronizing AUTO Git Repo: ${sub_dir}"
                    # bash /d/QLRepo/QLNotes/Config/Git/Scripts/git-sync.sh `pwd`
                    continue
                else
                    new_line
                    echo_info "This Is Not my Git Repo, Cause There's No File: mine, Skipping ..."
                fi
            else
                new_line
                echo_info "This Is Not A Git Repo, Handling Sub Directory ..."
                start_process "${sub_dir}"
            fi
        fi
    done
}

# cur_dir="$( cd "$( dirname "$0"  )" && pwd )"

cur_dir='/d/QLRepo'

start_process ${cur_dir}

new_line

echo_success "All Work Done!"

new_line

read -p "PRESSING ENTER TO EXIT ... "
