#!/usr/bin/env bash

ROOT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

LUA_PATH='not set'

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform      
    LUA_PATH='lua'
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    LUA_PATH='lua'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
    LUA_PATH='lua.exe'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
    LUA_PATH='lua.exe'
fi

${LUA_PATH} ${ROOT_PATH}/test.lua ${ROOT_PATH}/**/*_spec.lua