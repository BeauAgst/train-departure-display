#!/usr/bin/env bash

function check_online
{
    netcat -z -w 5 8.8.8.8 53 && echo 1 || echo 0
}

IS_ONLINE=$(check_online)
MAX_CHECKS=30
CHECK_COUNT=0

while [ $IS_ONLINE -eq 0 ]; do
    echo "No internet connection found, retrying..."
    sleep 10;
    IS_ONLINE=$(check_online)

    CHECK_COUNT=$[ $CHECK_COUNT + 1 ]
    if [ $CHECK_COUNT -gt $MAX_CHECKS ]; then
        break
    fi
done

if [ $IS_ONLINE -eq 0 ]; then
    echo "Failed to identify internet connection, exiting..."
    exit 1
fi

echo "Starting Train Departure Display..."

set -a
source .env
set +a

python src/main.py