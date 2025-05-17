#!/bin/bash

# Enhanced Git Sync Script
# Features: Clear function naming, separated pull/push operations
# Version: 3.1

# Color Output Functions
function echo_success() { echo -e "GIT-SYNC:" "\033[32m$1\033[0m"; }
function echo_failure() { echo -e "GIT-SYNC:" "\033[41;37m$1\033[0m"; }
function echo_warning() { echo -e "GIT-SYNC:" "\033[43;30m$1\033[0m"; }
function echo_info() { echo -e "GIT-SYNC:" "\033[40;37m$1\033[0m"; }
function echo_separator() { echo -e "GIT-SYNC:" "\033[44;37m$1\033[0m"; }

# Error Handling
function judgement() {
    local cmd=$1
    local result_code=$2
    local output=$3

    [[ -n "$output" ]] && echo_info "$output"

    if ((result_code != 0)); then
        case $result_code in
        1)
            echo_failure "ERROR: Common Unknown Error"
            ;;
        2)
            echo_failure "ERROR: Command mistake"
            ;;
        126)
            echo_failure "ERROR: Permission denied"
            ;;
        127)
            echo_failure "ERROR: Command not found"
            ;;
        128 | 129 | 130 | 131 | 137 | 141 | 143)
            echo_failure "ERROR: Signal error (code $result_code)"
            ;;
        255)
            echo_failure "ERROR: Invalid exit status"
            ;;
        *)
            echo_failure "UNEXPECTED CODE: $result_code"
            ;;
        esac

        echo_failure "Command failed: $cmd"
        read -p "Press Enter to exit ..."
        exit $result_code
    fi
}

# Core Functions
function new_line() { echo; }
function print_header() {
    new_line
    echo_separator "☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆";
}

function check_repo_status() {
    print_header
    echo_info "Checking repository status ..."
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo_failure "Not a Git repository!"
        exit 128
    fi
    local status_output=$(git status 2>&1)
    judgement "git status" $? "$status_output"
    echo "$status_output"
}

function detect_remotes() {
    print_header
    echo_info "Detecting remote configurations ..."
    local -g remotes=($(git remote | uniq))
    echo_info "Found remotes: ${remotes[*]:-None}"
}

function commit_changes() {
    print_header
    echo_info "Committing changes ..."

    git add --all 2>&1
    judgement "git add" $?

    local commit_output=$(git commit -m "-- Auto Commit --")
    judgement "git commit" $? "$commit_output"

    [[ -n "$commit_output" ]] && echo_info "$commit_output"
}

function pull_from_remote() {
    local remote=$1
    print_header
    echo_info "Pulling from $remote ..."

    local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
    [[ -z "$current_branch" ]] && current_branch="main"

    local pull_output=$(git pull "$remote" "$current_branch" 2>&1)
    judgement "git pull $remote" $? "$pull_output"
}

function push_to_remote() {
    local remote=$1
    print_header
    echo_info "Pushing to $remote ..."

    local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
    [[ -z "$current_branch" ]] && current_branch="main"

    # 获取最新的远程分支状态
    echo_info "Updating remote references..."
    git fetch "$remote" "$current_branch" >/dev/null 2>&1

    # 检测远程是否有未合并的更改
    if git rev-list "$remote/$current_branch" --not "$current_branch" | grep -q .; then
        echo_warning "Remote $remote/$current_branch has new unmerged changes. Skipping push."
        return 1
    fi

    # 平台特定推送处理
    local push_output
    case $remote in
    "gitee")
        echo_info "Pushing to Gitee with tags ..."
        push_output=$(git push --tags "$remote" "$current_branch" 2>&1)
        ;;
    "github")
        echo_info "Using safe push to GitHub ..."
        push_output=$(git push --force-with-lease "$remote" "$current_branch" 2>&1)
        ;;
    *)
        push_output=$(git push "$remote" "$current_branch" 2>&1)
        ;;
    esac

    judgement "git push $remote" $? "$push_output"
}

function sync_repository() {
    detect_remotes

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD -- || git ls-files --others --exclude-standard | grep -q .; then
        commit_changes
    fi

    # Phase 1: Pull from all remotes
    for remote in "${remotes[@]}"; do
        pull_from_remote "$remote"
    done

    # Phase 2: Push to all remotes
    for remote in "${remotes[@]}"; do
        push_to_remote "$remote"
    done
}

function main() {
    local target_dir=${1:-$(pwd)}

    if [[ ! -d "$target_dir" ]]; then
        echo_failure "Invalid directory: $target_dir"
        exit 1
    fi

    print_header
    echo_info "Starting sync for: $target_dir"

    if ! cd "$target_dir"; then
        echo_failure "Cannot access directory: $target_dir"
        exit 1
    fi

    check_repo_status
    sync_repository

    print_header
    echo_success "Sync completed successfully!"
    [[ -z $1 ]] && read -p "Press Enter to exit ..."
}

main "$@"
