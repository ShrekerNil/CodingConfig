#!/bin/sh

arr_excludes=("/d/QLRepo/Temps")

function check_excludes() {
      local cur_dir="$1"
      for exclude in "${arr_excludes[@]}"
      do
          if [[ "$cur_dir" == "$exclude" ]]; then
              return 1
          fi
      done
      return 0
}

if check_excludes "/d/QLRepo/Temps1"; then
    echo -e "${sub_dir} excluded, Skipping ...";
    continue
else
    echo -e "${sub_dir} not excluded, Executing ...";
fi
