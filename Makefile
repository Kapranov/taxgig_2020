V ?= @
SHELL := /usr/bin/env bash
ERLSERVICE := $(shell pgrep beam.smp)
NUM := {1..3}

ELIXIR = elixir

VERSION = $(shell git describe --tags --abbrev=0 | sed 's/^v//')

NO_COLOR=\033[0;0m
INFO_COLOR=\033[2;32m
SHOW_COLOR=\033[1;5;31m
STAT_COLOR=\033[2;33m

help:
													$(V)echo Please use \'make help\' or \'make ..any_parameters..\'

git-%:
													$(V)git add .
													$(V)git commit -m "$(@:git-%=%)"
													$(V)git push -u origin master

gitlog:
													$(V)git log -p -$(NUM)
gitpretty:
													$(v)git log --pretty=oneline

gitshort:
													$(V)git log --pretty=format:"%h - %an, %ar : %s"

pull:
													$(V)git pull

log:
													$(V)clear
													$(V)echo -e "\n"
													$(V)echo -e "\t$(SHOW_COLOR) There are commits:$(NO_COLOR) \n"
													$(V)git log --pretty="format:%ae|%an|%s"
													$(V)echo -e "\n"

kill:
													$(V)echo "Checking to see if Erlang process exists:"
													$(V)if [ "$(ERLSERVICE)" ]; then killall beam.smp && echo "Running Erlang Service Killed"; else echo "No Running Erlang Service!"; fi

clean:
													$(V)mix deps.clean --all
													$(V)mix do clean
													$(V)rm -fr _build/ ./deps/

packs:
													$(V)mix deps.get
													$(V)mix deps.update --all
													$(V)mix deps.get
recovery:
													$(V)mix deps.compile
													$(V)mix compile

test:
													$(V)clear
													$(V)echo -en "\n\t$(INFO_COLOR)Run server tests:$(NO_COLOR)\n\n"
													$(V)mix test --color

run: kill clean packs
													$(V)echo -en "\n\t$(STAT_COLOR) Run server https://localhost:$(NO_COLOR)$(INFO_COLOR)4001$(NO_COLOR)\n"
													$(V)iex -S mix

halt: kill
													$(V)echo -en "\n\t$(STAT_COLOR) Run server https://localhost:$(NO_COLOR)$(INFO_COLOR)4001$(NO_COLOR)\n"
													$(V)mix run --no-halt

start: kill clean packs
													$(V)echo -en "\n\t$(STAT_COLOR) Run server https://localhost:$(NO_COLOR)$(INFO_COLOR)4001$(NO_COLOR)\n"

all: test credo start

.PHONY: help git-% pull log kill clean packs test run halt start
