#!/bin/bash

word="$1"
if [[ "$word" == "" ]] || [[ "$#" -ne 1 ]]; then
    echo "usage: dic WORD"
    exit
fi

BOLD="$(tput bold)"
NORMAL="$(tput sgr0)"

dic() {
    local response
    response="$(\
        curl -s "https://tuna.thesaurus.com/pageData/$word" | \
        jq -r '.data')"

    if [[ "$response" == "" ]]; then
        echo "offline"
        return
    fi
    if [[ "$response" == "null" ]]; then
        echo "not found"
        return
    fi

    local definition
    definition="$(\
        echo "$response" | \
        jq -r '.definitionData.definitions[0].definition')"

    local synonyms
    synonyms="$(\
        echo "$response" | \
        jq -r '.definitionData.definitions[0].synonyms | sort_by(.similarity | tonumber) | reverse[] | "\(.term)(\(.similarity))"' | \
        sed ':a;N;$!ba;s/\n/, /g')"

    local antonyms
    antonyms="$(\
        echo "$response" | \
        jq -r '.definitionData.definitions[0].antonyms | sort_by(.similarity | tonumber)[] | "\(.term)(\(.similarity))"' | \
        sed ':a;N;$!ba;s/\n/, /g')"

    echo -e "${BOLD}definition${NORMAL}=$definition\n"
    echo -e "${BOLD}synonyms${NORMAL}=$synonyms\n"
    echo -e "${BOLD}antonyms${NORMAL}=$antonyms"
}

dic
