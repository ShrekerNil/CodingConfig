#!/bin/bash

# Define global associative array
declare -A SYNC_PATHS=(
    ["/d/QLRepo/QLConfig/Coding/Intellij/IdeaSetting_2023.3.8.zip"]="Intellij/"
    ["/d/QLRepo/QLConfig/Coding/Intellij/idea64.exe.vmoptions"]="Intellij/"
    ["/d/QLRepo/QLConfig/Sublime/"]="Editors/"
    ["/d/QLRepo/QLConfig/VSCode/"]="Editors/"
    ["/d/QLRepo/QLConfig/Typora/"]="Editors/"
    ["/d/QLRepo/QLConfig/Coding/MySQL/"]="./"
    ["/d/QLRepo/QLConfig/Coding/Maven/"]="./"
    ["/d/QLRepo/QLConfig/Scripts/"]="./"
)

# Synchronization function
sync_items() {
    local failed_items=()
    for source_path in "${!SYNC_PATHS[@]}"; do
        target_dir="${SYNC_PATHS[$source_path]}"
        # Handle spaces in paths
        source_path="${source_path//\ / }"

        # Create target directory
        mkdir -p "$target_dir" || {
            echo -e "\033[31mError: Failed to create directory $target_dir\033[0m"
            failed_items+=("$source_path -> $target_dir")
            continue
        }

        if [[ -f "$source_path" ]]; then
            cp -v "$source_path" "$target_dir" || {
                echo -e "\033[31mError: Failed to copy file $source_path to $target_dir\033[0m"
                failed_items+=("$source_path -> $target_dir")
            }
        elif [[ -d "$source_path" ]]; then
            cp -rv "$source_path" "$target_dir" || {
                echo -e "\033[31mError: Failed to copy directory $source_path to $target_dir\033[0m"
                failed_items+=("$source_path -> $target_dir")
            }
        else
            echo -e "\033[33mWarning: $source_path does not exist, skipped\033[0m"
        fi
    done
}

# Main execution logic
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    sync_items
    exit_code=0
    if [ ${#failed_items[@]} -ne 0 ]; then
        echo -e "\n\033[31mFailed items:\033[0m"
        for failed_item in "${failed_items[@]}"; do
            echo " - ${failed_item}"
        done
        exit_code=1
    else
        echo -e "\033[32mConfiguration synced to CodingConfig successfully!\033[0m"
    fi

    # if [ "${#BASH_SOURCE[@]}" -gt 1 ]; then
    #     echo "当前($0)脚本是被另一个脚本(${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]})调用的。"
    # else
    #     echo "当前($0)脚本是用户直接运行的。"
    #     read -p "Press [Enter] to continue ..." </dev/tty
    # fi

    exit $exit_code
fi
