#!/bin/bash

newsboat -x reload
output="$(newsboat -x print-unread)"
if [[ "$output" == "" ]]; then
    echo "📖 open"
else
    IFS=' ' read -r -a array <<< "$output"
    echo "📖 ${array[0]}"
fi
