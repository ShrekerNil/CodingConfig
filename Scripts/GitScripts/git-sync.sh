#!/bin/bash

# Enhanced Git Sync Script with Command Tracing
# Version: 4.1 (Added command tracing)

declare -g CMD_OUTPUT=""

# Color Output Functions
function echo_success() { echo -e "GIT-SYNC:" "\033[32m$1\033[0m"; }
function echo_failure() { echo -e "GIT-SYNC:" "\033[41;37m$1\033[0m"; }
function echo_warning() { echo -e "GIT-SYNC:" "\033[43;30m$1\033[0m"; }
function echo_info() { echo -e "GIT-SYNC:" "\033[40;37m$1\033[0m"; }
function echo_separator() { echo -e "GIT-SYNC:" "\033[44;37m$1\033[0m"; }

# Command executing function
function execute_command() {
    echo_info "------------------------"
    local cmd="$1"
    local suppress_output="${2:-false}"

    # print command
    echo_info "COMMAND: $cmd"

    # Executing command and capture output
    CMD_OUTPUT=$(eval "$cmd" 2>&1)
    local exit_code=$?

    # print output
    if ! $suppress_output; then
        [[ -n "$CMD_OUTPUT" ]] && echo_info "OUTPUT: \n$CMD_OUTPUT" || echo_info "OUTPUT: (no output)"
    fi

    return $exit_code
}

# Error Handling with special codes
function judgement() {
    local cmd=$1
    local result_code=$2
    local output=$3

    [[ -n "$output" ]] && echo_info "$output"

    if ((result_code != 0)); then
        case $result_code in
        1) echo_failure "ERROR: Common Unknown Error" ;;
        2) echo_failure "ERROR: Command mistake" ;;
        126) echo_failure "ERROR: Permission denied" ;;
        127) echo_failure "ERROR: Command not found" ;;
        128 | 129 | 130 | 131 | 137 | 141 | 143)
            echo_failure "ERROR: Signal error (code $result_code)"
            ;;
        201) return 0 ;; # Special case for skip push
        255) echo_failure "ERROR: Invalid exit status" ;;
        *) echo_failure "UNEXPECTED CODE: $result_code" ;;
        esac

        echo_failure "Command failed: $cmd"
        return $result_code
    fi
}

# Core Functions
function new_line() { echo; }
function print_header() {
    new_line
    echo_separator "╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱"
}

# Validate repository and detect changes
function check_repo_status() {
    print_header
    echo_info "Validating repository ..."

    # Check if in git repository
    execute_command "git rev-parse --is-inside-work-tree"
    local is_git_repo=$?
    if ((is_git_repo != 0)); then
        echo_failure "Not a Git repository!"
        exit 128
    fi

    # Detect all configured remotes
    execute_command "git remote"
    local remotes_output="$CMD_OUTPUT"
    local -g remotes=($(echo "$remotes_output" | uniq))

    if [[ ${#remotes[@]} -eq 0 ]]; then
        echo_warning "No git remotes configured!"
    else
        echo_info "Configured remotes: ${remotes[*]}"
    fi

    # Get current branch
    execute_command "git symbolic-ref --short HEAD"
    local current_branch="$CMD_OUTPUT"
    [[ -z "$current_branch" ]] && current_branch="main"
    echo_info "Working branch: $current_branch"

    # Check working directory status
    local has_uncommitted=0
    execute_command "git diff-index --quiet HEAD --"
    (($? != 0)) && has_uncommitted=1

    local has_untracked=0
    execute_command "git ls-files --others --exclude-standard"
    [[ -n "$CMD_OUTPUT" ]] && has_untracked=1

    # Check remote status for all remotes
    for remote in "${remotes[@]}"; do
        execute_command "git fetch $remote"
    done

    # Calculate divergence from remotes
    local -A behind_counts ahead_counts
    for remote in "${remotes[@]}"; do
        local remote_ref="$remote/$current_branch"
        execute_command "git rev-list --count $current_branch..$remote_ref" true
        behind_counts[$remote]=${CMD_OUTPUT:-0}
        execute_command "git rev-list --count $remote_ref..$current_branch" true
        ahead_counts[$remote]=${CMD_OUTPUT:-0}
    done

    # Determine required actions
    NEEDS_COMMIT=$((has_uncommitted || has_untracked))
    NEEDS_PULL=0
    NEEDS_PUSH=0

    for remote in "${remotes[@]}"; do
        ((${behind_counts[$remote]} > 0)) && NEEDS_PULL=1
        ((${ahead_counts[$remote]} > 0)) && NEEDS_PUSH=1
    done

    # Print status summary
    echo_info "Uncommitted changes: $has_uncommitted"
    echo_info "Untracked files: $has_untracked"
    for remote in "${remotes[@]}"; do
        echo_info "$remote: ${behind_counts[$remote]} behind, ${ahead_counts[$remote]} ahead"
    done
}

# Commit changes only when necessary
function commit_changes() {
    print_header
    echo_info "Checking staged changes ..."

    execute_command "git diff-index --quiet HEAD --"
    local staged_changes=$?
    execute_command "git ls-files --others --exclude-standard"
    local untracked_files=$?
    if ((staged_changes == 0 && untracked_files == 0)); then
        echo_info "No changes to commit."
        return 0
    fi

    execute_command "git add --all"
    judgement "git add" $? || return $?

    execute_command "git diff --cached --quiet"
    if (($? == 0)); then
        echo_info "No changes to commit after staging."
        return 0
    fi

    execute_command "git commit -m \"-- Auto Commit --\""
    judgement "git commit" $? || return $?
}

# Safe pull implementation with merge checks
function pull_from_remote() {
    local remote=$1
    print_header
    echo_info "Syncing from $remote ..."

    execute_command "git symbolic-ref --short HEAD"
    local current_branch=${output:-main}

    execute_command "git fetch $remote $current_branch"
    judgement "git fetch $remote" $? || return $?

    execute_command "git diff --quiet $remote/$current_branch $current_branch"
    if (($? == 0)); then
        echo_info "No changes to pull from $remote."
        return 0
    fi

    execute_command "git merge --no-edit $remote/$current_branch"
    judgement "git merge $remote" $? || return $?
}

# Safe push implementation with conflict checks
function push_to_remote() {
    local remote=$1
    print_header
    echo_info "Preparing push to $remote ..."

    execute_command "git symbolic-ref --short HEAD"
    local current_branch=${output:-main}

    execute_command "git fetch $remote"
    local has_conflicts=0
    execute_command "git rev-list $remote/$current_branch --not $current_branch"
    [[ -n "$output" ]] && has_conflicts=1

    if ((has_conflicts)); then
        echo_warning "Remote $remote has unmerged changes. Push skipped."
        return 201
    fi

    execute_command "git diff --quiet $remote/$current_branch HEAD"
    if (($? == 0)); then
        echo_info "No changes to push to $remote."
        return 0
    fi

    case $remote in
    "gitee")
        execute_command "git push $remote $current_branch"
        ;;
    "github")
        execute_command "git push --force-with-lease $remote $current_branch"
        ;;
    *)
        execute_command "git push $remote $current_branch"
        ;;
    esac
    judgement "git push $remote" $? || return $?
}

# Main synchronization workflow
function sync_repository() {
    check_repo_status

    # Commit if needed
    if ((NEEDS_COMMIT)); then
        commit_changes || return $?
    fi

    # Pull from all remotes
    local pull_errors=0
    echo_info "remotes：${remotes[@]}"
    for remote in "${remotes[@]}"; do
        if ! pull_from_remote "$remote"; then
            pull_errors=$((pull_errors + 1))
        fi
    done

    # Push to all remotes
    local push_errors=0
    for remote in "${remotes[@]}"; do
        if ! push_to_remote "$remote"; then
            [[ $? -eq 201 ]] || push_errors=$((push_errors + 1))
        fi
    done

    # Final status check
    local final_status=$(git status --porcelain 2>&1)
    if [[ -n "$final_status" ]]; then
        echo_warning "Uncommitted changes remain after sync."
        return 1
    fi

    return $((pull_errors + push_errors))
}

# Entry point
function main() {
    local target_dir=${1:-$(pwd)}

    # Validate directory
    if [[ ! -d "$target_dir" ]]; then
        echo_failure "Invalid directory: $target_dir"
        exit 200
    fi

    print_header
    echo_info "Initializing sync for: $target_dir"

    # Change working directory
    if ! cd "$target_dir"; then
        echo_failure "Access denied: $target_dir"
        exit 200
    fi

    # Execute synchronization
    sync_repository
    local sync_result=$?

    # Report final status
    new_line
    if [[ $sync_result -eq 0 ]]; then
        echo_success "Synchronization completed"
    else
        echo_failure "Completed with $sync_result errors"
        exit $sync_result
    fi

    new_line
    [[ -z $1 ]] && read -p "Press Enter to exit ..."
    exit 0
}

main "$@"
