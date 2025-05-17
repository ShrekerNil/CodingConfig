#!/bin/bash

# Function to display a new line
show_new_line() {
    echo
}

# Function to display error messages
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Function to copy files with logging
copy_files() {
    local source_file=$1
    local target_file=$2
    local log_file=$3

    if [ -f "$source_file" ]; then
        cp "$source_file" "$target_file" && echo "File copied successfully: $source_file -> $target_file"
        echo "$(date '+%Y-%m-%d %H:%M:%S'): Copied $source_file to $target_file" >> "$log_file"
    else
        echo "Error: Source file does not exist - $source_file"
        echo "$(date '+%Y-%m-%d %H:%M:%S'): Error: Source file does not exist - $source_file" >> "$log_file"
    fi
}

# Define software configurations with backup directories using single quotes
declare -A software_configs

software_configs=(
    ['Typora']="
    config_files=(
        '/c/Users/Shreker/AppData/Roaming/Typora/themes/purple-squence-light.css'
        '/c/Users/Shreker/AppData/Roaming/Typora/profile.data'
    )
    backup_dir='/d/QLRepo/QLConfig/Typora/Backups'"

    ['VSCode']="config_files=(
        '/c/Users/Shreker/AppData/Roaming/Code/User/settings.json'
        '/c/Users/Shreker/AppData/Roaming/Code/User/keybindings.json'
    )
    backup_dir='/d/QLRepo/QLConfig/VSCode/Backups'"

    ['Sublime']="config_files=(
        '/d/Programs/Tools/Sublime/Data/Packages/User/Preferences.sublime-settings'
        '/d/Programs/Tools/Sublime/Data/Packages/User/Default (Windows).sublime-keymap'
    )
    backup_dir='/d/QLRepo/QLConfig/Sublime/Backups'"
)

# 解析配置
function parse_config() {
    local config_name=$1
    local config_data=${software_configs[$config_name]}

    # 提取 backup_dir
    backup_dir=$(echo "$config_data" | grep -oP "backup_dir='\K[^']+")

    # 提取 config_files
    config_files=($(echo "$config_data" | grep -oP "config_files=\(([^)]+)\)" | grep -oP "'\K[^']+"))

    echo "Backup Directory for $config_name: $backup_dir"
    echo "Config Files for $config_name:"
    for file in "${config_files[@]}"; do
        echo "  - $file"
    done
}

# 测试
# parse_config "Typora"
# parse_config "VSCode"
# parse_config "Sublime"

# Initialize backup directories and log files
declare -A LOG_FILES

for software in "${!software_configs[@]}"; do
    # 使用 eval 来解析 config_files 和 backup_dir
    eval "${software_configs[$software]}"

    # 创建备份目录
    if [ ! -d "${backup_dir}" ]; then
        mkdir -p "${backup_dir}"
        echo "Created backup directory for ${software}: ${backup_dir}"
    fi

    # 初始化日志文件
    LOG_FILES[$software]="${backup_dir}/backup.log"
done

# Function to list available software with indices
list_software() {
    echo "Available software to backup/recover:"
    index=1
    for software in "${!software_configs[@]}"; do
        echo " $index) $software"
        index=$((index + 1))
    done
}

# Function to list files for a given software
list_files() {
    local software=$1
    eval "${software_configs[$software]}"

    echo "================================"
    echo "Files to backup for $software:"
    for file in "${config_files[@]}"; do
        echo " - $file"
    done
    echo "================================"
    echo "Files to recover for $software:"
    for file in "${config_files[@]}"; do
        backup_file="${backup_dir}/$(basename "$file")"
        echo " - $backup_file"
    done
}

# Main script logic
while true; do
    show_new_line
    list_software
    read -p "Enter the number of the software to operate on (or 'exit' to quit): " choice

    if [[ "$choice" == "exit" ]]; then
        echo "Exiting the script."
        break
    fi

    # Validate input
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a number."
        continue
    fi

    # Convert choice to index
    index=$((choice - 1))
    software_keys=("${!software_configs[@]}")
    if [[ "$index" -lt 0 || "$index" -ge "${#software_keys[@]}" ]]; then
        echo "Choice out of range. Please try again."
        continue
    fi

    # Get selected software
    software_choice="${software_keys[$index]}"

    # Get backup directory and config files for the selected software
    eval "${software_configs[$software_choice]}"

    # Get log file
    LOG_FILE="${backup_dir}/backup.log"

    # List files
    show_new_line
    list_files "$software_choice"

    # Choose operation
    echo
    read -p "Do you want to (1) Backup or (2) Recover? (1/2): " operation_choice

    case "$operation_choice" in
        1)
            echo "Starting backup process for $software_choice..."
            for source_file in "${config_files[@]}"; do
                backup_file="${backup_dir}/$(basename "$source_file")"
                copy_files "$source_file" "$backup_file" "$LOG_FILE"
            done
            ;;
        2)
            echo "Starting recovery process for $software_choice..."
            for source_file in "${config_files[@]}"; do
                backup_file="${backup_dir}/$(basename "$source_file")"
                copy_files "$backup_file" "$source_file" "$LOG_FILE"
            done
            ;;
        *)
            echo "Invalid operation choice. Please try again."
            ;;
    esac

    show_new_line
    read -p "Press ENTER to continue or Any key to exit: " cont
    if [[ -z "$cont" ]]; then
        continue
    else
        break
    fi
done
