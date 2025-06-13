# shell_lib.sh

# -------------------------------
# Color Codes
# -------------------------------
COLOR_RED=$(tput setaf 1 2>/dev/null || echo "\033[31m")
COLOR_GREEN=$(tput setaf 2 2>/dev/null || echo "\033[32m")
COLOR_YELLOW=$(tput setaf 3 2>/dev/null || echo "\033[33m")
COLOR_BLUE=$(tput setaf 4 2>/dev/null || echo "\033[34m")
COLOR_RESET=$(tput sgr0 2>/dev/null || echo "\033[0m")

# -------------------------------
# Logging Function
# -------------------------------
# Parameters:
#   \$1 - Log level (INFO, WARN, ERROR, SUCCESS)
#   \$2 - Log message
log_message() {
    local level=$1
    local message=$2
    local color_prefix=""
    local timestamp
    timestamp=$(date +"%Y-%m-%d %T")

    # 设置颜色前缀（仅当输出到终端时）
    if [[ -t 1 ]]; then
        case $level in
            "SUCCESS") color_prefix="${COLOR_GREEN}" ;;
            "ERROR") color_prefix="${COLOR_RED}" ;;
            "WARN") color_prefix="${COLOR_YELLOW}" ;;
            "INFO") color_prefix="${COLOR_RESET}" ;;
            "TIP") color_prefix="${COLOR_BLUE}" ;;
        esac
    fi

    # 修改 log_message 函数中的 printf 语句
    if [[ -t 1 ]]; then
        # 终端输出：带颜色
        printf "[%s] %b%-7s - %s%b\n" \
            "$timestamp" "$color_prefix" "${level}" "${message}" "${COLOR_RESET}" >&2  # 添加 >&2
    else
        # 文件输出：纯文本（无颜色代码）
        printf "[%s] %-7s - %s\n" \
            "$timestamp" "${level}" "${message}" >&2  # 添加 >&2
    fi

}

# -------------------------------
# New Line Function
# -------------------------------
function log_new_line() {
    printf "\n"
}

function log_tip() {
    log_message "TIP" "$@"
}

function log_info() {
    log_message "INFO" "$@"
}

function log_warn() {
    log_message "WARN" "$@"
}

function log_error() {
    log_message "ERROR" "$@"
}

function log_success() {
    log_message "SUCCESS" "$@"
}

function log_separator1() {
    log_new_line
    log_message "TIP" "===================================================================================="
}

function log_separator2() {
    log_message "TIP" "↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔↔"
}

function log_separator3() {
    log_message "TIP" "→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→→"
}

function log_separator4() {
    log_message "TIP" "-----------------------------------------------------"
}

# -------------------------------
# Exporting the functions
# -------------------------------
export -f log_message
export -f log_tip
export -f log_info
export -f log_warn
export -f log_error
export -f log_success
export -f log_new_line
export -f log_separator1
export -f log_separator2
export -f log_separator3
export -f log_separator4
