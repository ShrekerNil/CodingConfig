#!/bin/bash

# Enhanced Git Sync Script
# Combined version with multi-remote support and conditional operations
# Features:
# - Multiple remote handling
# - Granular change detection
# - Safe push/pull operations
# - Detailed status tracking
# Version: 4.0

# Color Output Functions
function echo_success() { echo -e "GIT-SYNC:" "\033[32m$1\033[0m"; }
function echo_failure() { echo -e "GIT-SYNC:" "\033[41;37m$1\033[0m"; }
function echo_warning() { echo -e "GIT-SYNC:" "\033[43;30m$1\033[0m"; }
function echo_info() { echo -e "GIT-SYNC:" "\033[40;37m$1\033[0m"; }
function echo_separator() { echo -e "GIT-SYNC:" "\033[44;37m$1\033[0m"; }

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
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo_failure "Not a Git repository!"
        exit 128
    fi

    # Detect all configured remotes
    local -g remotes=($(git remote | uniq))
    echo_info "Configured remotes: ${remotes[*]:-None}"

    # Get current branch
    local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
    [[ -z "$current_branch" ]] && current_branch="main"
    echo_info "Working branch: $current_branch"

    # ==== 修正开始 ==== #
    # Check working directory status
    local has_uncommitted=0
    git diff-index --quiet HEAD -- || has_uncommitted=1

    local has_untracked=0
    git ls-files --others --exclude-standard | grep -q . && has_untracked=1
    # ==== 修正结束 ==== #

    # Check remote status for all remotes
    for remote in "${remotes[@]}"; do
        git fetch "$remote" >/dev/null 2>&1
    done

    # Calculate divergence from remotes
    local -A behind_counts ahead_counts
    for remote in "${remotes[@]}"; do
        local remote_ref="$remote/$current_branch"
        behind_counts[$remote]=$(git rev-list --count "$current_branch..$remote_ref" 2>/dev/null)
        ahead_counts[$remote]=$(git rev-list --count "$remote_ref..$current_branch" 2>/dev/null)
    done

    # Determine required actions
    NEEDS_COMMIT=$((has_uncommitted || has_untracked))  # 使用修正后的变量
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

    # Check if there's anything to commit
    if git diff-index --quiet HEAD -- && ! git ls-files --others --exclude-standard | grep -q .; then
        echo_info "No changes to commit."
        return 0
    fi

    # Stage all changes
    git add --all 2>&1
    judgement "git add" $? || return $?

    # Verify changes after staging
    if git diff --cached --quiet; then
        echo_info "No changes to commit after staging."
        return 0
    fi

    # Perform commit
    local commit_output=$(git commit -m "-- Auto Commit --")
    judgement "git commit" $? "$commit_output" || return $?
    [[ -n "$commit_output" ]] && echo_info "$commit_output"
}

# Safe pull implementation with merge checks
function pull_from_remote() {
    local remote=$1
    print_header
    echo_info "Syncing from $remote ..."

    local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")

    # Fetch updates first
    local fetch_output=$(git fetch "$remote" "$current_branch" 2>&1)
    judgement "git fetch $remote" $? "$fetch_output" || return $?

    # Check if updates are available
    if git diff --quiet "$remote/$current_branch" "$current_branch"; then
        echo_info "No changes to pull from $remote."
        return 0
    fi

    # Merge changes
    local merge_output=$(git merge --no-edit "$remote/$current_branch" 2>&1)
    judgement "git merge $remote" $? "$merge_output" || return $?
    [[ -n "$merge_output" ]] && echo_info "$merge_output"
}

# Safe push implementation with conflict checks
function push_to_remote() {
    local remote=$1
    print_header
    echo_info "Preparing push to $remote ..."

    local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")

    # Check remote status
    git fetch "$remote" >/dev/null 2>&1

    # Detect unmerged remote changes
    if git rev-list "$remote/$current_branch" --not "$current_branch" | grep -q .; then
        echo_warning "Remote $remote has unmerged changes. Push skipped."
        return 201
    fi

    # Check if local has changes to push
    if git diff --quiet "$remote/$current_branch" "HEAD"; then
        echo_info "No changes to push to $remote."
        return 0
    fi

    # Execute push with remote-specific strategies
    local push_output
    case $remote in
    "gitee") # Special handling for Gitee
        push_output=$(git push --tags "$remote" "$current_branch" 2>&1)
        ;;
    "github") # Force-with-lease for GitHub
        push_output=$(git push --force-with-lease "$remote" "$current_branch" 2>&1)
        ;;
    *) # Default push strategy
        push_output=$(git push "$remote" "$current_branch" 2>&1)
        ;;
    esac

    judgement "git push $remote" $? "$push_output" || return $?
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
