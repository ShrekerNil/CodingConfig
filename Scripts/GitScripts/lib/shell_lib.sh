#!/bin/bash

# @Author: Shreker.Nil
# @Date:   2024-11-17 00:51:30
# @Last Modified by:   Shreker.Nil
# @Last Modified time: 2024-11-17 01:00:33

function echo_sucess() {
    echo -e "\033[32m$1\033[0m"
}

function echo_failure() {
    echo -e "\033[41;37m$1\033[0m"
}

function echo_warning() {
    echo -e "\033[43;37m$1\033[0m"
}

function echo_separator() {
    echo -e "\033[44;37m$1\033[0m"
}

function echo_info() {
    echo -e "\033[40;37m$1\033[0m"
}

function print_start_line() {
    new_line
    echo_separator "===================================================="
}

function new_line() {
    echo -e "\n"
}

function is_running_by_yser() {
    if [[ "${#BASH_SOURCE[@]}" -gt 1 ]]; then
        #echo "Current Script ($0) is being called by (${BASH_SOURCE[${#BASH_SOURCE[@]}-1]})"
        echo false
    else
        #echo "Current Script ($0) is running by user directly."
        echo true
    fi
}

function pause_exec() {
    read -p "PRESSING [Enter] TO EXIT ... "
}

# 下次使用的时候修改
function judgement() {
    cmd=$1
    result_code=$2
    output=$3

    if [[ ${#output} -gt 0 ]]; then
        echo_info "${output}"
    fi

    if [[ $result_code -ne 0 ]]; then
        if [[ $result_code -eq 1 ]]; then
            echo_failure "ERROR: Common Unkown Error."
        else
            if [[ $result_code -eq 2 ]]; then
                echo_failure "ERROR: Command mistake: $result_code"
            elif [[ $result_code -eq 126 ]]; then
                echo_failure "ERROR: Unexecutable: $result_code"
            elif [[ $result_code -eq 127 ]]; then
                echo_failure "ERROR: Not a command: $result_code"
            elif [[ $result_code -eq 255 ]]; then
                echo_failure "ERROR: Exit status Invalid: $result_code"
            elif [[ $result_code -ge 128 ]]; then
                signal=$((result_code - 128))
                echo_failure "ERROR: Terminated by signal $signal"
            else
                echo_failure "UNEXPECTED CODE: $result_code"
            fi
        fi
        new_line
        echo_failure "Command Of \"$cmd\" Executed Failure. Please Try After Checking It."
        read -p "Pressing Enter To Resume ... "
        exit $result_code
    else
        new_line
        echo_sucess "Command Of \"$cmd\" Executed Successfully."
    fi
}
