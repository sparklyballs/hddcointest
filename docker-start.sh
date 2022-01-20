#!/usr/bin/env bash

# shellcheck disable=SC2154
hddcoin start "${service}"

trap "echo Shutting down ...; hddcoin stop all -d; exit 0" SIGINT SIGTERM

# shellcheck disable=SC2154
if [[ ${log_to_file} == 'true' ]]; then
  # Ensures the log file actually exists, so we can tail successfully
  touch "$HDDCOIN_ROOT/log/debug.log"
  tail -F "$HDDCOIN_ROOT/log/debug.log" &
fi

while true; do sleep 1; done
