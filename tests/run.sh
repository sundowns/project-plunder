#!/usr/bin/env bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[1;31m'
NC='\033[0m' # No Color

ROOT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

is_ci=false

while getopts 'c' flag; do
    case "${flag}" in
        c) is_ci=true ;;
    esac
done

LUA_PATH='not set'

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform      
    LUA_PATH='lua'
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    LUA_PATH='lua'
    if [ "$is_ci" = true ]; then
        LUA_PATH='lua5.3'
    fi
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
    LUA_PATH='lua.exe'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
    LUA_PATH='lua.exe'
fi

printf "\n${CYAN}=====| RUNNING ALL TESTS |=====${NC}\n\n"

printf "${WHITE}"
${LUA_PATH} ${ROOT_PATH}/test.lua ${ROOT_PATH}/**/*_spec.lua
if [ $? -eq 0 ]; then
    printf "\n${GREEN}=====| ALL TESTS PASSED :D |=====${NC}\n\n"
    exit 0
else
    printf "\n${RED}=====| SOME TESTS FAILED :c |=====${NC}\n\n"
    exit 1
fi
