#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=elephone
VENDOR=trunk

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

CM_ROOT="$MY_DIR"/../../..

HELPER="$CM_ROOT"/vendor/cm/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

if [ $# -eq 0 ]; then
  SRC=adb
  SRC2=adb
else
  if [ $# -eq 2 ]; then
    SRC=$1
    SRC2=$2
  else
    echo "$0: bad number of arguments"
    echo ""
    echo "usage: $0 [PATH_TO_EXPANDED_TRUNK_ROM PATH_TO_EXPANDED_CRACKLING_ROM]"
    echo ""
    echo "If no PATH_TO_EXPANDED_*_ROM is specified, blobs will be extracted from"
    echo "the device using adb pull."
    exit 1
  fi
fi

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$CM_ROOT"

extract "$MY_DIR"/proprietary-files-crackling.txt "$SRC2"
extract "$MY_DIR"/proprietary-files-qc.txt "$SRC"
extract "$MY_DIR"/proprietary-files.txt "$SRC"


"$MY_DIR"/setup-makefiles.sh
