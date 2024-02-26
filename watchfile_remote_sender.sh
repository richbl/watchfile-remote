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
# Watchfile Remote Sender (watchfile_remote_sender): periodically send update
# file to the remote receiver (watchfile_remote_receiver)
#
#   Requirements: None
#   Globals: None
#   Arguments: None
#   Outputs: Loops indefinitely sending file updates to the receiver
#   Returns: None

# -----------------------------------------------------------------------------
# script declarations
#
readonly SRC_DIR="/home/user/watchfile_remote"
readonly DST_SERVER="user@yourdomain.com"
readonly DST_DIR="/home/user/watchfile_remote"
readonly WATCHFILE="the_watchfile"

while :; do

    # IMPORTANT
    #
    # The following `scp` call assumes that a secure connection (e.g., ssh public
    # key exchange) has already been established between source and destination
    # machines
    #
    # If no such connection has been established, then `scp` can be used by passing a
    # password directly on command line via `sshpass` as follows:
    #
    # sshpass -p "password" scp "${SRC_DIR}"/"${WATCHFILE}" "${DST_SERVER}":"${DST_DIR}"
    #
    # Otherwise, use the more secure syntax below:
    #
    scp "${SRC_DIR}"/"${WATCHFILE}" "${DST_SERVER}":"${DST_DIR}"

    sleep 300 # sleep for 5 minutes

done
