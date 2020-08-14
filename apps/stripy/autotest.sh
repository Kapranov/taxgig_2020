#!/usr/bin/env bash
# Start inotifywait and run test if test file or file inside lib is modified
if [ "$1" = "--umbrella" ] || [ "$1" = "-u" ]
then
  while true; do
    inotifywait -r -e modify,move,create,delete test/ && mix test
  done
else
  while true; do
    inotifywait -r -e modify,move,create,delete test/ && mix test
  done
fi
