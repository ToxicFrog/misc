# Support functions for taskwarrior wrappers like `books`.

NAME=${NAME:=$(basename $ZSH_SCRIPT)}

# List of (name:regex) pairs in order they should be checked.
declare -a TASK_COMMANDS
# Mappings from name to handler and to help text.
declare -A TASK_COMMAND_HANDLERS
declare -A TASK_COMMAND_HELP

# init-config <defaults name>
# creates a default configuration file that just includes the defaults file.
function task/init-config {
  if [[ -e $TASKRC ]]; then
    return 0
  fi

  echo "include $(dirname $(realpath $ZSH_SCRIPT))/$1" > $TASKRC
  shift
  while [[ $1 ]]; do
    echo "$1" >> $TASKRC
    shift
  done
}

# Process a taskwarrior command line to expand year:foo pseudo-filters into
# end: filters that taskwarrior understands.
# Returning arrays is hard, so it just drops it into $TASK_ARGV and expects
# the caller to use it.
function task/-parse-argv {
  while [[ $1 ]]; do
    case "$1" in
      year:all)
        TASK_ARGV+="rc.context:none"
        ;;
      year:now) TASK_ARGV+="( end.after:$(date +%Y)-01-01 or end: )" ;;
      year:*)
        local year="${1/year:/}"
        TASK_ARGV+="( end.after:$year-01-01 and end.before:$((year+1))-01-01 )"
        ;;
      *) TASK_ARGV+="$1" ;;
    esac
    shift
  done
}

# task/register <name> <pattern> <handler> <<EOF ..help text.. EOF
function task/register {
  TASK_COMMANDS+="$1:$2"
  TASK_COMMAND_HANDLERS[$1]="$3"
  TASK_COMMAND_HELP[$1]="$(cat)"
}

function task/dispatch {
  local TASK_ARGV=()
  task/-parse-argv "$@"
  set -- "${TASK_ARGV[@]}"
  echo

  for cmd in ${TASK_COMMANDS[@]}; do
    local name=$(echo $cmd | cut -d: -f1)
    local regex=$(echo $cmd | cut -d: -f2-)
    if [[ $* =~ $regex ]]; then
      ${TASK_COMMAND_HANDLERS[$name]} "$@"
      return $?
    fi
  done
  # No matching command; pass it through to taskwarrior unaltered.
  \task "$@"
}

task/register reset-config '^reset-config$' task/-reset-config <<EOF

  $NAME reset-config

Delete the configuration file for this taskwarrior frontend. It will be
automatically recreated with default settings on next run.
EOF
function task/-reset-config {
  rm -v $TASKRC
}

task/register help '^help' task/-help <<EOF

  $NAME help
  $NAME help <command>

With no arguments, list all available commands.

With an argument, display help for that command, if available.
EOF
function task/-help {
  shift
  if [[ $1 ]]; then
    if (( ${+TASK_COMMAND_HELP[$1]} )); then
      printf '%s\n' "${TASK_COMMAND_HELP[$1]}"
    else
      echo "No such command `$1`."
      return 1
    fi
  else
    echo "Available commands:"
    printf "  %s\\n" ${TASK_COMMANDS[@]} | cut -d: -f1 | sort
    echo "For detailed help, use \`$0 help <command>\`."
  fi
}
