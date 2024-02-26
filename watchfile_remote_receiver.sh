#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# -----------------------------------------------------------------------------
# Copyright (C) Business Learning Incorporated (businesslearninginc.com)
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License at
# <http://www.gnu.org/licenses/> for more details.
#
# -----------------------------------------------------------------------------
#
# Watchfile Remote Receiver (watchfile_remote_receiver): watch a file for changes
#
#   Requirements: None
#   Globals: None
#   Arguments: None
#   Outputs: None
#     Side-effect(s): Loops indefinitely watching for file changes
#   Returns: None

# -----------------------------------------------------------------------------
# script functions
#

# -----------------------------------------------------------------------------
# Get the modification date of a file
#   Globals: None
#   Arguments:
#     $1: target directory
#     $2: filename
#   Outputs:
#     The modification date in Unix epoch seconds
#   Returns: None
#
function get_file_date() {
  printf "%s" "$(date -r "$1"/"$2" +%s)"
}

# -----------------------------------------------------------------------------
# script declarations
#
readonly SRC_DIR="/home/user/watchfile_remote"
readonly WATCHFILE="the_watchfile"
readonly EMAIL_ADDR="richbl@gmail.com"

# get initial timestamp from file
initial_timestamp=$(get_file_date "${SRC_DIR}" "${WATCHFILE}")
is_internet=true

while :; do

  # if the internet is up, sleep for 10 minutes, else sleep less often (for 7 minutes) in order to
  # check more often for status change
  if [[ $is_internet == true ]]; then
    sleep 600 # 10 minutes
  else
    sleep 420 # 7 minutes
  fi

  # get updated timestamp from file
  updated_timestamp=$(get_file_date "${SRC_DIR}" "${WATCHFILE}")

  # if the timestamps are the same, then no updates received over this last interval... and that's not good!
  if [[ $initial_timestamp -eq $updated_timestamp ]]; then

    if [[ $is_internet == true ]]; then
      echo "Bummer... our home internet service is down!" | mailx -s "Home Internet Service is Down!" "$EMAIL_ADDR"
      is_internet=false
    fi

  else

    if [[ $is_internet == false ]]; then
      echo "Yes... our home internet service is back up!" | mailx -s "Home Internet Service is Back Up!" "$EMAIL_ADDR"
      is_internet=true
    fi

  fi

  # update timestamp to most recent and go back to sleep
  initial_timestamp=${updated_timestamp}

done
