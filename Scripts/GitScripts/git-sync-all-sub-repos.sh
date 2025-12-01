#!/usr/bin/env bash

# git-sync-all-sub-repos.sh

# Debug mode switch (set to true to enable)
DEBUG_MODE=false

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

# Global configuration
ROOT_DIR='/d/Repos'
EXCLUDES=(
    "${ROOT_DIR}/Temps"
    # Add more excluded paths here
)

# Log file configuration
LOG_FILE="${ROOT_DIR}/git-sync-all-sub-repos.log"

# Initialize associative array for directory exclusion checks
declare -A EXCLUDE_MAP
for dir in "${EXCLUDES[@]}"; do
    EXCLUDE_MAP["$dir"]=1
done

#######################################
# Directory exclusion check
# Parameters:
#   \$1 - Target directory path
# Returns:
#   0 - Should be excluded
#   1 - Should not be excluded
#######################################
should_exclude() {
    [[ -n "${EXCLUDE_MAP[$1]}" ]] && return 0
    return 1
}

#######################################
# Check if exit code should be considered success
# Parameters:
#   \$1 - Exit code
#######################################
is_success_code() {
    local code=$1
    [[ $code -eq 0 || $code -eq 200 || $code -eq 1 ]]
}

#######################################
# Safe wrapper for executing external script
# Parameters:
#   \$1 - Target directory
#######################################
run_git_sync() {
    local target_dir=$1
    # local sync_script="$(dirname "${BASH_SOURCE[0]}")/git-sync.sh"
    local sync_script="${SOURCE_DIR}/git-sync.sh"
    local display_path
    # display_path=$(echo "$target_dir" | iconv -c -f UTF-8 -t ASCII//TRANSLIT)
    display_path="$target_dir"

    if [[ ! -x "$sync_script" ]]; then
        log_error "Sync script missing: ${display_path}"
        return 1
    fi

    log_info "Starting sync: ${display_path}"

    # Execute and capture output and exit code
    bash "$sync_script" "$target_dir" 2>&1 | tee -a "$LOG_FILE"
    local exit_code=$?

    # Debug information
    if [[ "$DEBUG_MODE" == true ]]; then
        log_tip "First got exit code: $exit_code Path: $target_dir"
    fi

    if is_success_code $exit_code; then
        return 0
    else
        return $exit_code
    fi
}

#######################################
# Recursively process directories
# Parameters:
#   \$1 - Current processing directory path
#######################################
process_directory() {
    local current_dir=$1

    # Process directories (handle spaces in paths)
    while IFS= read -r -d $'\0' sub_dir; do
        [[ "$sub_dir" == "$current_dir" ]] && continue # Skip current directory

        log_new_line
        log_separator1
        log_info "Found subdirectory: $(basename "$sub_dir")"

        # Exclusion check
        if should_exclude "$sub_dir"; then
            log_warn "Excluded directory: ${sub_dir}"
            continue
        fi

        # Process directory
        if cd "$sub_dir" 2>/dev/null; then
            if [[ -d ".git" ]]; then
                # Print header
                log_separator2
                log_info "Start synchronizing root: ${current_dir}"

                handle_git_repo "$sub_dir"
            else
                log_info "Not a Git repository, processing subdirectories..."
                process_directory "$sub_dir"
            fi
        else
            log_error "Cannot access directory: ${sub_dir}"
        fi
    done < <(find "$current_dir" -maxdepth 1 -type d -print0)
    log_new_line
}

#######################################
# Handle Git repository logic
# Parameters:
#   \$1 - Repository directory path
#######################################
handle_git_repo() {
    local repo_dir=$1
    local display_path
    display_path=$(echo "$repo_dir" | iconv -c -f UTF-8 -t ASCII//TRANSLIT)

    if [[ -f "mine" ]]; then
        run_git_sync "$repo_dir" || {
            log_error "Sync failed (code $?) for: ${display_path}"
            return 1
        }
        log_success "Sync completed: ${display_path}"
    else
        log_warn "Skipping unmanaged repo: ${display_path}"
    fi
}

#######################################
# Main execution function
#######################################
main() {
    # Initialize logging
    : >"$LOG_FILE" # Clear old logs
    log_info "=========== Git Sync Script Started (v${SCRIPT_VERSION}) ==========="

    # Verify root directory existence
    if [[ ! -d "$ROOT_DIR" ]]; then
        log_error "Root directory not found: ${ROOT_DIR}"
        exit 1
    fi

    # Execute main process
    process_directory "$ROOT_DIR"

    # Completion prompt
    log_success "All operations completed"
    read -rp "Press [Enter] to exit..."
}

# Execution entry point
main "$@"
