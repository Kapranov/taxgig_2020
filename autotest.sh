#!/usr/bin/env bash
# Start inotifywait and run test if test file or file inside lib is modified
if [ "$1" = "--umbrella" ] || [ "$1" = "-u" ]
then
  while true; do
    inotifywait -r -e modify,move,create,delete apps/ && mix test --include integration
  done
else
  while true; do
    inotifywait -r -e modify,move,create,delete lib/ test/ && mix test --include integration
  done
fi
