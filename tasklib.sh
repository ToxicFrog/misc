# Support functions for taskwarrior wrappers like `books`.

# init-config <defaults name>
# creates a default configuration file that just includes the defaults file.
function init-config {
  if [[ ! -e $TASKRC ]]; then
    echo "include $(dirname $(realpath $0))/$1" > $TASKRC
  fi
}

# Process a taskwarrior command line to expand year:foo pseudo-filters into
# end: filters that taskwarrior understands.
# Returning arrays is hard, so it just drops it into $TASK_ARGV and expects
# the caller to use it.
function process-year-filter {
  TASK_ARGV=()
  while [[ $1 ]]; do
    if [[ $1 == year:all ]]; then
      # Drop this argument entirely, default behaviour is to show everything.
      true
    elif [[ $1 == year:now ]]; then
      local year="$(date +%Y)"
      TASK_ARGV+="( end.after:$year-01-01 or end: )"
    elif [[ $1 == year:* ]]; then
      local year="${1/year:/}"
      TASK_ARGV+="( end.after:$year-01-01 and end.before:$((year+1))-01-01 )"
    else
      TASK_ARGV+="$1"
    fi
    shift
  done
}
