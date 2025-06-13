#!/usr/bin/env bash
# 统一日志模块 git-logger.sh v1.0

# 初始化颜色（自动检测终端支持）
init_colors() {
    if [[ -t 1 ]] && tput setaf 1 >/dev/null 2>&1; then
        COLOR_RED=$(tput setaf 1)
        COLOR_GREEN=$(tput setaf 2)
        COLOR_YELLOW=$(tput setaf 3)
        COLOR_BLUE=$(tput setaf 4)
        COLOR_RESET=$(tput sgr0)
    else
        COLOR_RED=''
        COLOR_GREEN=''
        COLOR_YELLOW=''
        COLOR_BLUE=''
        COLOR_RESET=''
    fi
}

# 核心日志函数
log() {
    local level="$1"
    local message="$2"
    local script_name="${3:-GIT-SYNC}"  # 默认脚本名前缀
    local timestamp=$(date "+%Y-%m-%d %T")
    local color=""

    # 设置颜色和级别标签
    case "$level" in
        "SUCCESS") color="$COLOR_GREEN" ;;
        "ERROR")   color="$COLOR_RED" ;;
        "WARN")    color="$COLOR_YELLOW" ;;
        "INFO")    color="$COLOR_BLUE" ;;
        *)         color="$COLOR_RESET" ;;
    esac

    # 格式化输出
    local log_line="[$timestamp] ${script_name} - ${level}: ${message}"

    # 终端带颜色输出，日志文件无颜色
    if [[ -t 1 ]]; then
        echo -e "${color}${log_line}${COLOR_RESET}"
    else
        echo "$log_line"
    fi

    # 写入日志文件（追加模式）
    echo "$log_line" >> "${LOG_FILE:-/tmp/git-sync.log}"
}

# 分隔符生成器
log_separator() {
    local char="${1:-=}"
    local width="${2:-70}"
    log "INFO" "$(printf '%*s' $width | tr ' ' "$char")" "$3"
}

# 初始化颜色
init_colors