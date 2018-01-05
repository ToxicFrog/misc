#!/usr/bin/env zsh

# Habitica/TaskWarrior integration.
# Enable with `alias task=/path/to/habitask.zsh` in your rc, then use `task`.

# Hooks the following taskwarrior commands:
# `task`, `task list`, and `task next` to display unfinished dailies
# `task add ...` to add the task to Habitica
# `task ... delete` to delete the task from Habitica
# `task ... start` and `task ... stop` to update the task description on Habitica
# `task ... done` to mark the task finished on Habitica
# All of this behaviour is in addition to the default taskwarrior behaviour.

# Assumptions we make:
# - `add` will always be $1
# - all other command words will always be the last argument
# - in the latter case, $1 will be a comma-separated list of tasks to modify,
#   and we don't need to care about later arguments.

#### Utility functions ####

function task/-task {
  \task rc.defaultwidth=0 rc.verbose=nothing "$@" 2>/dev/null
}

function task/-infer-command {
  if (($# == 0)); then
    echo -n "next"
  elif [[ $1 == add* ]]; then
    echo -n "$1"
  else
    echo -n "${argv[-1]}"
  fi
}

#### New commands ####

function task/-get-daily-id {
  local dailies=($(habitica list type alias | egrep '^daily' | cut -f2))
  local id=1
  while [[ ${dailies[(r)d$id]} == d$id ]]; do
    ((++id))
  done
  echo d$id
}

# task add-daily <description>
function task/pre-add-daily {
  shift
  local id="$(task/-get-daily-id)"
  habitica add type daily frequency daily alias "$id" text "$*"
  echo
}

#### Hook functions ####

function task/post-next {
  task/post-list
}

function task/post-list {
  habitica list type completed alias text \
    | egrep '^daily' \
    | cut -f2- \
    | egrep '^false' \
    | cut -f2- \
    | sort
}

function task/post-add {
  local last=$(\task ids | cut -d- -f2)
  local uuid=$(\task $last uuids)
  local desc=$(\task _get $uuid.description)
  local date=$(\task _get $uuid.due)
  habitica add type todo alias "task-$uuid" text "$desc" date "$date"
}

function task/pre-delete {
  if [[ $1 == d* ]]; then
    habitica delete ${(s:,:)argv[1,-2]}
    exit $?
  fi

  set -- $(task/-task "${argv[1,-2]}" uuids)
  for uuid in "$@"; do
    habitica delete "task-$uuid"
  done
}

function task/post-start {
  set -- $(task/-task "${argv[1,-2]}" uuids)
  # todo: add [started] to the end of the description
}

function task/post-stop {
  set -- $(task/-task "${argv[1,-2]}" uuids)
  # todo: strip [started] from the end of the description
}

function task/post-log {
  # todo: fetch the task from `task completed` and log it in habitica
}

function task/pre-done {
  if [[ $1 == d* ]]; then
    habitica up ${(s:,:)argv[1,-2]}
    exit $?
  fi

  set -- $(task/-task "${argv[1,-2]}" uuids)
  # todo: this should happen in post-done so only tasks that are actually done
  # are marked done in habitica, since the user might answer "n" when taskwarrior
  # asks to confirm.
  for uuid in "$@"; do
    habitica up "task-$uuid"
  done
}

function task/hook {
  local cmd=$(task/-infer-command "$@")

  local pre="$(typeset +f task/pre-$cmd)"
  local post="$(typeset +f task/post-$cmd)"

  if [[ $pre ]]; then
    $pre $@ || return $?
  fi

  \task $@

  if [[ $post ]]; then
    $post $@
  fi
}

task/hook "$@"
