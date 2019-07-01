#!/usr/bin/env bash

ROOT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

lua ${ROOT_PATH}/test.lua ${ROOT_PATH}/**/*_spec.lua