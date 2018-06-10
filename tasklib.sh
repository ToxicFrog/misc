# Support functions for taskwarrior wrappers like `books`.

if [[ $ZSH_SCRIPT ]]; then
  NAME=${NAME:=$(basename $ZSH_SCRIPT)}
fi

# List of (name:regex) pairs in order they should be checked.
declare -a TASK_COMMANDS
# Mappings from name to handler and to help text.
declare -A TASK_COMMAND_HANDLERS
declare -A TASK_COMMAND_HELP

# task/register <name> <pattern> <handler> <<EOF ..help text.. EOF
function task/register {
  TASK_COMMANDS+="$1:$2"
  TASK_COMMAND_HANDLERS[$1]="$3"
  TASK_COMMAND_HELP[$1]="$(cat)"
}

# init-config <defaults name> [additional file contents...]
# creates a default configuration file that just includes the defaults file,
# plus any additional settings listed.
# Clients should call this after setting TASKRC and before doing anything else.
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
        TASK_ARGV+="rc.context:"
        ;;
      year:now)
        TASK_ARGV+="$(task/year-filter $YEAR)"
        TASK_ARGV+="rc.context:"
        ;;
      year:*)
        TASK_ARGV+="$(task/year-filter ${arg/year:/})"
        TASK_ARGV+="rc.context:"
        ;;
      *) TASK_ARGV+="$arg" ;;
    esac
    shift
  done
}

# task/dispatch $@
# Main entry point to the command dispatcher.
function task/dispatch {
  local TASK_ARGV=()
  task/-parse-argv "$@"
  set -- "${TASK_ARGV[@]}"

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

# select <field> <order> <filters...>
# Return all values of field, including duplicates, sorted in the specified order.
# e.g. `select uuid end+ +programming` returns all the values of 'end', in ascending order,
# but only for tasks that have the `programming` tag set.
task/register select '^select' task/select-cmd <<EOF

  $NAME select <field1>[,field2,...] <sort> [filter...]

For each task matching filter, output the listed fields, separated by an
UNSPECIFIED type and quantity of whitespace. Handle with care.
EOF
function task/select-cmd { shift; task/select "$@"; }
function task/select {
  local fields="$1"
  local sort="$2"
  shift 2
  \task rc.verbose:nothing rc.report.list.filter: \
    rc.report.list.labels:"$fields" rc.report.list.columns:"$fields" \
    rc.report.list.sort:"$sort" \
    "$@" list
}

# year-filter <year range>
# returns a taskwarrior filter clause that shows only tasks from the given year
# range. A range can be any of:
#  2014         tasks from 2014 only
#  2014-2016    tasks from 2014, 2015, or 2016
#  2014-        tasks from 2014 to the present
#      -2016    tasks from the beginning of time to the end of 2016
#
# "from $YEAR", in practice, means:
# - is finished, and was finished during $YEAR, OR
# - is started, and was started during or before $YEAR, OR
# - is pending, and was added during or before $YEAR.
# In effect, this means "tasks that were finished during $YEAR, or were pending
# or in-progress for at least part of $YEAR."
function task/year-filter {
  local start end
  case "$1" in
    *-)
      start="${1%-}-01-01"
      end="2099-01-01"
      ;;
    -*)
      start="1985-01-01"
      end="$((${1#-}+1))-01-01"
      ;;
    *-*)
      start="${1%-*}-01-01"
      end="$((${1#*-}+1))-01-01"
      ;;
    *)
      start="$1-01-01"
      end="$(($1+1))-01-01"
      ;;
  esac
  # Items that were completed within the given date range.
  local isfinished="( +COMPLETED and end.after:$start and end.before:$end )"
  # Items that are active, and were active during the given date range.
  local isactive="( +ACTIVE and start.before:$end )"
  # Items that are not yet started, and existed during the given date range.
  local ispending="( +PENDING and -ACTIVE and entered.before:$end )"
  echo -n "( $isfinished or $isactive or $ispending )"
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
  LAST=$(task/select uuid end+ +COMPLETED | tail -n1)
  shift
  \task $LAST annotate "$@"
}

task/register annocat 'annocat$' task/-annocat <<EOF

  $NAME [filter] annocat

Annotate the selected entries with text entered on stdin. If no filter is specified,
annotates the most recently completed entry.
EOF
function task/-annocat {
  shift -p
  if [[ ! $* ]]; then
    set -- "$(task/select uuid end+ +COMPLETED | tail -n1)"
  fi
  echo "## About to annotate the following:"
  task "$@" uuids | task/printf "  \x1B[4m%description.desc%s\x1B[0m by %author%s\n"
  echo "## Enter the annotation, ^D when done."
  \task "$@" annotate "$(cat)"
}

# task/get-field uuid field
# Wrapper around task/select and \task get to extract individual fields.
# Outputs the field on stdout, NULL TERMINATED for use with xargs -0.
# It is currently very simple:
# - if the field is "annotations", it outputs all annotations
# - if the field starts with ., it is assumed to be a DOM node and _get is used
# - otherwise it is assumed to be a formatted field and task/select is used.
function task/get-field {
  case "$2" in
    annotations)
      local n=1
      while true; do
        local annotation="$(\task _get "$1.annotations.$n.description")"
        if [[ ! $annotation ]]; then break; fi
        if (( n > 1 )); then printf '\n'; fi
        printf '%s\n' "$annotation"
        ((++n))
      done
      ;;
    .*)
      printf '%s' "$(\task _get "$1$2")"
      ;;
    *)
      printf '%s' "$(task/select "$2" "uuid+" rc.context: "uuid:$1")"
      ;;
  esac
}

# Utility function: task/printf <format>
# Reads task UUIDs from stdin and outputs each one in the given format.
# The format should have sequences of the form %fieldname%s for each field.
# Notes on fieldname:
# - %.foo.bar% is a DOM node
# - %foo.bar% is column foo with format bar
# - %foo|bar% is column foo piped through function bar
function task/printf {
  fields="$(echo -E "$1" | egrep -o '%[a-z_.|/-]+%.' | cut -d% -f2)"
  format="$(echo -E "$1" | sed -E 's,%[a-z_.|/-]+(%.),\1,g')"

  xargs -n1 printf '%s\n' | while read uuid; do
    # printf '\r\x1B[0K%s' "$(task/get-field $uuid .description)" >&2
    echo -E "$fields" \
    | while read field; do
      # If field has the format 'field|formatter', pipe it through the latter
      if [[ $field == *\|* ]]; then
        local formatter="$(echo -E "$field" | cut -d\| -f2)"
        field="$(echo -E "$field" | cut -d\| -f1)"
        task/get-field "$uuid" "$field" | "$formatter"
      else
        task/get-field "$uuid" "$field"
      fi
      printf '\0'
    done \
    | xargs -0 printf "$format"
    # printf '\n'
  done
}
