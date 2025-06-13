#!/bin/bash

# Traverse all .mp4 files in the current directory
for file in *.mp4; do
    # Use a regular expression to match and extract the new filename
    if [[ "$file" =~ ^(.*)[-_]720P[\ -_]*高清[-_]AVC([0-9]+)(\..+)$ ]]; then
        # Extract parts of the filename
        prefix="${BASH_REMATCH[1]}"
        number="${BASH_REMATCH[2]}"
        extension="${BASH_REMATCH[3]}"

        # Build the new filename
        new_name="${prefix}${extension}"

        # Output the renaming operation (optional)
        echo "Renaming '$file' to '$new_name'"

        # Execute the renaming
        mv "$file" "$new_name"
    else
        echo "Skipping '$file': Does not match the expected naming format."
    fi
done
