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

# select <field> <order> <filters...>
# Return all values of field, including duplicates, sorted in the specified order.
# e.g. `select uuid end+ +programming` returns all the values of 'end', in ascending order,
# but only for tasks that have the `programming` tag set.
function task/select {
  local field="$1"
  local sort="$2"
  shift 2
  \task rc.verbose:nothing rc.report.list.filter: rc.report.list.labels:_ \
    rc.report.list.columns:"$field" rc.report.list.sort:"$sort" \
    "$@" list
}

# year-filter <year>
# returns a taskwarrior filter clause that shows only tasks from the given year.
# "from $YEAR", in practice, means:
# - is finished, and was finished during $YEAR, OR
# - is started, and was started during or before $YEAR, OR
# - is pending, and was added during or before $YEAR.
# In effect, this means "tasks that were finished during $YEAR, or were pending
# or in-progress for at least part of $YEAR."
function task/year-filter {
  local isfinished="( +COMPLETED and end.after:$1-01-01 and end.before:$(($1+1))-01-01 )"
  local isactive="( +ACTIVE and start.before:$(($1+1))-01-01 )"
  local ispending="( +PENDING and -ACTIVE and entered.before:$(($1+1))-01-01 )"
  echo -n "$isfinished or $isactive or $ispending"
}

# Placeholder for argument mapping function.
# Programs can override this for argument preprocessing.
function task/map-arg { echo -E "$@" }

# Process a taskwarrior command line to expand year:foo pseudo-filters into
# end: filters that taskwarrior understands.
# Returning arrays is hard, so it just drops it into $TASK_ARGV and expects
# the caller to use it.
# It assumes that the default context is some kind of year-scoping, so if the
# user specifies a year: filter it also disables the context.
# See task/year-filter for details on the filter meaning.
function task/-parse-argv {
  while [[ $1 ]]; do
    local arg="$(task/map-arg "$1")"
    case "$1" in
      year:all)
        TASK_ARGV+="rc.context:none"
        ;;
      year:now)
        TASK_ARGV+="$(task/year-filter $YEAR)"
        TASK_ARGV+="rc.context:none"
        ;;
      year:*)
        TASK_ARGV+="$(task/year-filter ${arg/year:/})"
        TASK_ARGV+="rc.context:none"
        ;;
      *) TASK_ARGV+="$arg" ;;
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

task/register annote '^annote' task/-annote <<EOF

  $NAME annote <text>

Annotate the most recently finished entry with the given text and the current
timestamp.
EOF
function task/-annote {
  LAST=$(task/select uuid end+ | tail -n1)
  shift
  \task $LAST annotate "$@"
}
