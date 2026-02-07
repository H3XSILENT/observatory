#!/usr/bin/env bash

log() {
    echo -e "\e[36m[$(date +%H:%M:%S)]\e[0m $1"
}

die() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    exit 1
}

random_ua() {
    shuf -n1 "$UA_FILE"
}

delay() {
    [[ "$STEALTH" == true ]] && sleep "$DELAY"
}
