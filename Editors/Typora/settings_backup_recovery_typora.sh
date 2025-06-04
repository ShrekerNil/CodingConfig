#!/bin/bash

show_new_line() {
    echo -e "\n"
}

# Program Name
program_operate="Typora"

# Arrays for file backups and recoveries
file_recoveries=("/c/Users/Shreker/AppData/Roaming/Typora/themes/purple-square-light.css"
    "/c/Users/Shreker/AppData/Roaming/Typora/themes/purple-square-dark.css"
    "/c/Users/Shreker/AppData/Roaming/Typora/profile.data")
file_backups=("./Settings/purple-square-light.css"
    "./Settings/purple-square-dark.css"
    "./Settings/profile.data")

# Function to check if file exists
file_exists() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Function to copy files
copy_files() {
    local source_file=$1
    local target_file=$2

    if file_exists "$source_file"; then
        cp "$source_file" "$target_file"
        echo "File copied successfully: $source_file -> $target_file"
    else
        echo "Error: Source file does not exist - $source_file"
    fi
}

# Main script logic
while true; do
    echo "=============================================="
    echo "Please choose an option for ${program_operate}:"
    echo "1) Backup files"
    echo "2) Recover files"
    read -p "Enter your choice (1/2): " choice

    case $choice in
        1)
            echo "Starting backup process..."
            for i in "${!file_backups[@]}"; do
                copy_files "${file_recoveries[$i]}" "${file_backups[$i]}"
            done
            ;;
        2)
            echo "Starting recovery process..."
            for i in "${!file_recoveries[@]}"; do
                copy_files "${file_backups[$i]}" "${file_recoveries[$i]}"
            done
            ;;
        *)
            echo "Invalid option selected."
            ;;
    esac

    show_new_line
    # read -p "Do you want to continue? (yes/no): " cont
    # if [[ "$cont" != "yes" ]]; then
    #     break
    # fi
    read -p "Press ENTER to continue or Any other key to exit: " cont
    show_new_line
    show_new_line
    if [[ -z "$cont" ]]; then
        continue
    else
        break
    fi
done

echo "Exiting the script."
