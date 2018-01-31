# Support functions for taskwarrior wrappers like `books`.

# init-config <defaults name>
# creates a default configuration file that just includes the defaults file.
function init-config {
  if [[ -e $TASKRC ]]; then
    return 0
  fi

  echo "include $(dirname $(realpath $0))/$1" > $TASKRC
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
function process-year-filter {
  TASK_ARGV=()
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
