#!/usr/bin/env zsh

#
#    Copyright (c) 2020 Project CHIP Authors
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

git pull
git submodule update --init
set -e


# Build script for GN examples GitHub workflow.
CHIPTOOL_DIR="./third_party/connectedhomeip"
source "${CHIPTOOL_DIR}/scripts/activate.sh"

GN_ARGS=()

EXAMPLE_DIR="./"
shift
OUTPUT_DIR="out/"
shift

NINJA_ARGS=()
for arg; do
    case $arg in
        -v)
            NINJA_ARGS+=(-v)
            ;;
        *=*)
            GN_ARGS+=("$arg")
            ;;
        *import*)
            GN_ARGS+=("$arg")
            ;;
        *)
            echo >&2 "invalid argument: $arg"
            exit 2
            ;;
    esac
done

set -x
env

gn gen --check --fail-on-unused-args --root="$EXAMPLE_DIR" "$OUTPUT_DIR" --args="${GN_ARGS[*]}"

ninja -C "$OUTPUT_DIR" "${NINJA_ARGS[@]}"