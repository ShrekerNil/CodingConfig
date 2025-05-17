#!/usr/bin/env bash

# Version information
SCRIPT_VERSION="1.2.0"

# Debug mode switch (set to true to enable)
DEBUG_MODE=false

# Color code constants
COLOR_RED='\033[41;37m'
COLOR_GREEN='\033[32m'
COLOR_YELLOW='\033[43;37m'
COLOR_BLUE_BG='\033[44;37m'
COLOR_PURPLE_BG='\033[45;37m'
COLOR_RESET='\033[0m'

# Log file configuration
LOG_FILE="${HOME}/git_sync.log"

# Global configuration
ROOT_DIR='/d/QLRepo'
EXCLUDES=(
    "/d/QLRepo/Temps"
    # Add more excluded paths here
)

# Initialize associative array for faster exclusion checks
declare -A EXCLUDE_MAP
for dir in "${EXCLUDES[@]}"; do
    EXCLUDE_MAP["$dir"]=1
done

new_line() {
    printf "\n"
}

#######################################
# Enhanced logging function
# Parameters:
#   $1 - Log level (INFO, WARN, ERROR, SUCCESS)
#   $2 - Log message
#######################################
log_message() {
    local level=$1
    local message=$2
    local timestamp
    timestamp=$(date +"%Y-%m-%d %T")

    # Set color prefix
    case $level in
    "SUCCESS") local color_prefix="${COLOR_GREEN}" ;;
    "ERROR") local color_prefix="${COLOR_RED}" ;;
    "WARN") local color_prefix="${COLOR_YELLOW}" ;;
    *) local color_prefix="${COLOR_RESET}" ;;
    esac

    # Format output
    printf "GIT-SYNC-CTRL: [%s] %b%-7s%b - %s\n" \
        "$timestamp" \
        "$color_prefix" "${level}" "${COLOR_RESET}" \
        "${message}" | tee -a "$LOG_FILE"
}

#######################################
# Directory exclusion check
# Parameters:
#   $1 - Target directory path
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
#   $1 - Exit code
#######################################
is_success_code() {
    local code=$1
    [[ $code -eq 0 || $code -eq 200 || $code -eq 1 ]]
}

#######################################
# Safe wrapper for executing external script
# Parameters:
#   $1 - Target directory
#######################################
run_git_sync() {
    local target_dir=$1
    # local sync_script="$(dirname "${BASH_SOURCE[0]}")/git-sync.sh"
    local sync_script="/d/QLRepo/QLConfig/Linux/Scripts/GitScripts/git-sync.sh"
    # local display_path=$(echo "$target_dir" | iconv -c -f UTF-8 -t ASCII//TRANSLIT)
    local display_path=$(echo "$target_dir")

    if [[ ! -x "$sync_script" ]]; then
        log_message "ERROR" "Sync script missing: ${display_path}"
        return 1
    fi

    log_message "INFO" "Starting sync: ${display_path}"

    # Execute and capture output and exit code
    bash "$sync_script" "$target_dir" 2>&1 | tee -a "$LOG_FILE"
    local exit_code=$?

    # Debug information
    # [[ "$DEBUG_MODE" == true ]] && log_message "DEBUG" "Exit code: $exit_code Path: $target_dir"
    log_message "DEBUG" "First got exit code: $exit_code Path: $target_dir"

    if [[ $exit_code -eq 0 ]] || [[ $exit_code -eq 200 ]] || [[ $exit_code -eq 201 ]]; then
        return 0
    else
        return $exit_code
    fi
}

#######################################
# Recursively process directories
# Parameters:
#   $1 - Current processing directory path
#######################################
process_directory() {
    local current_dir=$1

    # Process directories (handle spaces in paths)
    find "$current_dir" -maxdepth 1 -type d -print0 | while IFS= read -r -d $'\0' sub_dir; do
        [[ "$sub_dir" == "$current_dir" ]] && continue # Skip current directory

        new_line
        log_message "INFO" "============================================================================"
        log_message "INFO" "Found subdirectory: $(basename "$sub_dir")"

        # Exclusion check
        if should_exclude "$sub_dir"; then
            log_message "WARN" "Excluded directory: ${sub_dir}"
            continue
        fi

        # Process directory
        if cd "$sub_dir" 2>/dev/null; then
            if [[ -d ".git" ]]; then
                # Print header
                log_message "INFO" "--------------------------------------------------------"
                log_message "INFO" "Start synchronizing root: ${current_dir}"

                handle_git_repo "$sub_dir"
            else
                log_message "INFO" "Not a Git repository, processing subdirectories..."
                process_directory "$sub_dir"
            fi
        else
            log_message "ERROR" "Cannot access directory: ${sub_dir}"
        fi
    done
    new_line
}

#######################################
# Handle Git repository logic
# Parameters:
#   $1 - Repository directory path
#######################################
handle_git_repo() {
    local repo_dir=$1
    local display_path=$(echo "$repo_dir" | iconv -c -f UTF-8 -t ASCII//TRANSLIT)

    if [[ -f "mine" ]]; then
        run_git_sync "$repo_dir" || {
            log_message "ERROR" "Sync failed (code $?) for: ${display_path}"
            return 1
        }
        log_message "SUCCESS" "Sync completed: ${display_path}"
    else
        log_message "WARN" "Skipping unmanaged repo: ${display_path}"
    fi
}

#######################################
# Main execution function
#######################################
main() {
    # Initialize logging
    : >"$LOG_FILE" # Clear old logs
    log_message "INFO" "=========== Git Sync Script Started (v${SCRIPT_VERSION}) ==========="

    # Verify root directory existence
    if [[ ! -d "$ROOT_DIR" ]]; then
        log_message "ERROR" "Root directory not found: ${ROOT_DIR}"
        exit 1
    fi

    # Execute main process
    process_directory "$ROOT_DIR"

    # Completion prompt
    log_message "SUCCESS" "All operations completed"
    read -rp "Press [Enter] to exit..."
}

# Execution entry point
main "$@"
