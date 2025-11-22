#!/usr/bin/env bash

# git-sync.sh

# Enhanced Git Sync Script with Strict Error Handling

# 状态码处理规范：
#   退出代码      含义            触发场景示例
#   0             成功执行        所有操作正常完成
#   1             通用错误        命令执行失败、参数错误等
#   2             仓库状态错误    非Git仓库、分离HEAD状态
#   3             配置错误        无远程仓库配置
#   4             同步冲突        合并冲突、推送冲突
#   5             网络错误        拉取/推送操作超时

declare -a REMOTES=()
declare CURRENT_BRANCH=""

# -------------------------------
# Source the logging library
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHLIB="$SOURCE_DIR/../shlib/shell_lib.sh"
if [[ -f "${SHLIB}" ]]; then
    source "${SHLIB}"
else
    echo "ERROR: CAN'T FIND ${SHLIB}"
    exit 1
fi
log_info "--- shell_lib.sh HAS BEEN IMPORTED ---"

# -------------------------------
# Error Handling Functions
# -------------------------------
function fatal_error() {
    local msg="$1"
    local exit_code=${2:-1} # 默认退出码为1

    log_error "FATAL: $msg"
    log_separator3
    log_error "ABORTED: Process failed with exit code $exit_code"
    exit $exit_code
}

# -------------------------------
# Command Execution Functions
# 用于常规命令 - 失败立即退出
# -------------------------------
function execute_command() {
    log_info "Executing: $*"
    output=$("$@" 2>&1)
    status=$?
    if [ $status -ne 0 ]; then
        log_error "Command failed with status $status"
        log_error "Output: \n${output:-(No output)}"
        fatal_error "Command failed: $*" $status
    fi

    log_info "Output: ${output:-(No output)}"
    return 0
}


# -------------------------------
# Command Execution Functions
# 用于状态检查命令 - 不视为错误，只返回状态
# -------------------------------
function check_status() {
    log_info "Checking status: $*"
    if output=$("$@" 2>&1); then
        log_info "Status: success"
        return 0
    else
        local status=$?
        log_info "Status: $status (not fatal)"
        return $status
    fi
}

# -------------------------------
# Core Functions
# -------------------------------
function check_untracked_files() {
    log_info "Checking untracked files..."
    if check_status git ls-files --others --exclude-standard; then
        [ -z "$output" ] && return 0
    fi
    return 1
}

function has_untracked_changes() {
    # 检查工作区是否有未暂存的修改
    if ! check_status git diff-index --quiet HEAD --; then
        return 0 # 有未暂存的修改
    fi

    # 检查暂存区是否有修改
    if ! check_status git diff --cached --quiet; then
        return 0 # 有暂存的修改
    fi

    return 1 # 没有未提交的修改
}

function get_remotes() {
    log_info "Fetching remotes..."
    execute_command git remote
    mapfile -t REMOTES <<<"$output"
    [ ${#REMOTES[@]} -eq 0 ] && fatal_error "No remotes configured" 3
}

function get_current_branch() {
    log_info "Getting current branch..."

    local branch_output
    if ! branch_output=$(git symbolic-ref --short HEAD 2>/dev/null); then
        fatal_error "Detached HEAD state or invalid branch" 2
    fi

    CURRENT_BRANCH="$branch_output"
    log_info "Current branch: $CURRENT_BRANCH"
}

function special_remote_order() {
    local has_gitee=0 has_github=0
    for remote in "${REMOTES[@]}"; do
        [[ "$remote" == "gitee" ]] && has_gitee=1
        [[ "$remote" == "github" ]] && has_github=1
    done
    ((has_gitee && has_github))
}

function pull_remotes() {
    if has_untracked_changes; then
        log_warn "Working directory not clean before pull, committing changes..."
        execute_command git add .
        execute_command git commit -m "Pre-pull commit: $(date +%Y%m%d_%H%M%S)"
    fi

    if special_remote_order; then
        execute_command git pull gitee "$CURRENT_BRANCH"
        execute_command git pull github "$CURRENT_BRANCH"
    else
        for remote in "${REMOTES[@]}"; do
            execute_command git pull "$remote" "$CURRENT_BRANCH"
        done
    fi
}

function needs_push() {
    for remote in "${REMOTES[@]}"; do
        log_info "Checking remote branch: $remote/$CURRENT_BRANCH"
        if ! check_status git ls-remote --exit-code --heads "$remote" "$CURRENT_BRANCH"; then
            log_warn "Remote branch missing on $remote (needs initial push)"
            return 0
        fi

        log_info "Calculating commit difference for $remote"
        local commit_count
        if ! commit_count=$(git rev-list --count "$remote/$CURRENT_BRANCH"..HEAD 2>/dev/null); then
            log_error "Failed to get commit count for $remote"
            return 0
        fi

        log_info "Commit difference for $remote: $commit_count"
        # 确保只处理数字
        if [[ "$commit_count" =~ ^[0-9]+$ ]] && [ "$commit_count" -gt 0 ]; then
            return 0
        fi
    done
    return 1
}

function push_remotes() {
    if [[ ! -f "mine" ]]; then
        log_warn "Did not detecte 'mine' file, skipping push operations"
        return 0
    fi

    if special_remote_order; then
        execute_command git push gitee "$CURRENT_BRANCH"
        execute_command git push github "$CURRENT_BRANCH"
    else
        for remote in "${REMOTES[@]}"; do
            execute_command git push "$remote" "$CURRENT_BRANCH"
        done
    fi
}

# -------------------------------
# Main Workflow
# -------------------------------
function main() {
    log_separator3
    log_info "Step 1: Validate repository ..."
    execute_command git rev-parse --is-inside-work-tree

    # 新增：切换到仓库根目录
    repo_root=$(git rev-parse --show-toplevel) || fatal_error "Failed to get repository root" 2
    cd "$repo_root" || fatal_error "Failed to cd to repository root" 2
    log_info "Changed to repository root: $repo_root"

    log_separator3
    log_info "Step 2: Checking bash file 'syncing.sh' ..."
    if [[ -f ./syncing.sh ]]; then
        execute_command bash ./syncing.sh
    fi

    log_separator3
    log_info "Step 3: Handle untracked files ..."
    if check_untracked_files; then
        log_info "No untracked files"
    else
        log_separator4
        log_warn "Adding untracked files..."
        execute_command git add .
    fi

    log_separator3
    log_info "Step 4: Handle uncommitted changes ..."
    if has_untracked_changes; then
        log_separator4
        log_info "Staging changes..."
        execute_command git add .

        if check_status git diff --cached --quiet; then
            log_info "No changes to commit"
        else
            log_separator4
            log_info "Committing changes..."
            execute_command git commit -m "Auto commit: $(date +%Y%m%d_%H%M%S)"
        fi
    else
        log_info "No uncommitted changes"
    fi

    log_separator3
    log_info "Step 5: Handle remotes ..."

    log_separator4
    get_remotes

    log_separator4
    get_current_branch

    log_separator4
    pull_remotes

    log_separator3
    log_info "Step 6: Handle push ..."
    if needs_push; then
        log_separator4
        log_info "Pushing changes..."
        push_remotes
    else
        log_success "No changes need to push ..."
    fi

    log_success "Synchronization completed"
}

# -------------------------------
# Entry Point
# -------------------------------
main || {
    final_exit=$?
    log_separator3
    log_error "ABORTED: Process failed with exit code $final_exit"
    exit $final_exit
}

log_separator3
exit 0
