#!/bin/bash

json_file="$1"
if [[ "$json_file" == "" ]] || [[ "$#" -ne 1 ]]; then
    echo "usage: format_json json_file"
    exit
fi

format_json() {
    local file_name
    file_name=$(basename "$json_file")

    local tmp_file
    tmp_file=$(mktemp "/tmp/$file_name.XXXXXXXXX")

    json_pp < "$json_file" > "$tmp_file"

    mv "$tmp_file" "$json_file"
}

format_json
