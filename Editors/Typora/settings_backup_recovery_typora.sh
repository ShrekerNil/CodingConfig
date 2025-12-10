#!/bin/bash

# Program Name
program_operate="Typora"
profile_dir="/c/Users/Shreker/AppData/Roaming/Typora"
theme_dir="${profile_dir}/themes"

# Arrays for file backups and recoveries
file_recoveries=(
    "${theme_dir}/purple-square-light.css"
    "${theme_dir}/purple-square-dark.css"
    "${theme_dir}/codemirror-dark.css"
    "${theme_dir}/codemirror-light.css"
    "${theme_dir}/reset_all.css"
    "${profile_dir}/profile.data"
)
file_backups=(
    "./Settings/purple-square-light.css"
    "./Settings/purple-square-dark.css"
    "./Settings/codemirror-dark.css"
    "./Settings/codemirror-light.css"
    "./Settings/reset_all.css"
    "./Settings/profile.data"
)

# Function to copy files with error checking
copy_files() {
    local source_file=$1
    local target_file=$2

    if [[ -f "$source_file" ]]; then
        cp "$source_file" "$target_file"
        echo "File copied successfully: $source_file -> $target_file"
    else
        echo "Error: Source file does not exist - $source_file"
    fi
}

# Function to clear the themes directory before recovery
clear_themes_directory() {
    # Remove all .css files in the directory
    find "$theme_dir" -type f -name "*.css" -exec rm -f {} \;
    # Remove all directories in the themes directory (excluding hidden ones, i.e., starting with a dot)
    find "$theme_dir" -mindepth 1 -maxdepth 1 -type d ! -name ".*" -exec rm -rf {} +
}

# Main script logic
while true; do
    echo "=============================================="
    echo "Please choose an option for ${program_operate}:"
    echo "  1) Backup files"
    echo "  2) Recover files"
    echo "=============================================="
    read -p "Enter your choice (1/2): " choice

    case $choice in
        1)
            echo "Starting backup process..."
            for i in "${!file_backups[@]}"; do
                copy_files "${file_recoveries[$i]}" "${file_backups[$i]}"
            done
            ;;
        2)
            echo "Clearing Typora's themes directory before recovery..."
            clear_themes_directory
            echo "Starting recovery process..."
            for i in "${!file_backups[@]}"; do
                copy_files "${file_backups[$i]}" "${file_recoveries[$i]}"
            done
            ;;
        *)
            echo "Invalid option selected."
            continue
            ;;
    esac

    read -p "Press ENTER to continue or any other key to exit: " cont
    echo ""
    echo ""
    echo ""
    if [[ -z "$cont" ]]; then
        continue
    else
        break
    fi
done

echo "Exiting the script."
