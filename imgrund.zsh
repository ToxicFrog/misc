#!/usr/bin/env zsh

set -e

readonly OUT=/srv/www/pub/covid

function scrape-twitter {
  phantomjs /dev/stdin <<EOF
    var page = require('webpage').create();

    page.onResourceRequested = function(metadata, handle) {
      if (metadata.url.indexOf('timeline/profile') >= 0) {
        let headers = {}
        console.log('url "' + metadata.url + '"');
        for (h of metadata.headers) {
          console.log('header "' + h.name + ': ' + h.value + '"');
        }
        setTimeout(_ => phantom.exit(), 0);
      }
    }

    page.open('https://twitter.com/imgrund', function() {
      setTimeout(function() {
        phantom.exit();
      }, 10000);
    });
EOF
}

function init-twitter {
  echo "Initializing Twitter cookie jar."
  scrape-twitter | fgrep -v TypeError > curl
  id=\"$(head -n1 /tmp/$$/curl | egrep -o 'timeline/profile/[0-9]+.json' | egrep -o '[0-9]+')\"
  [[ $id ]] || { echo "Couldn't initialize twitter, giving up."; exit 1; }
}

function fetch-timeline {
  echo "Fetching tweets."
  curl -s -K curl > json
}

function parse-timeline {
  thread_id=$(cat json | jq -r '
    [.globalObjects.tweets[]
      | select(.full_text | contains("ONTARIO REGIONAL METRIC"))]
    | sort_by(.id_str)
    | reverse[0]
    .conversation_id_str'
  )
  # pinned=$(cat json | jq ".globalObjects.users.$id.pinned_tweet_ids_str[0]")
  when=$(date -d "$(cat json | jq -r .globalObjects.tweets.\"$thread_id\".created_at)" -I)
  echo "Found tweet $thread_id for $when"
}

function fetch-images {
  echo "Fetching images."
  local when="$1"
  local thread_id="$2"
  mkdir -p $when
  n=0
  cat json \
  | jq -r "[.globalObjects.tweets[] | select(.conversation_id_str == \"$thread_id\")] | sort_by(.id_str)[].entities.media[].media_url_https" \
  | while read img; do
    wget -nc -nv -O "$when/$(printf %02d $n)-$(basename $img)" "$img"
    ((++n))
  done
}

function generate-album {
  echo "Generating album."
  fgallery -j 4 -d -i -t -o --index /pub/covid/ $when $OUT/$when
  rm $OUT/today $OUT/index.html
  printf '<pre>\n<a href="today/">TODAY</a>\n' > index.html
  ls $OUT | while read dir; do
    printf '<a href="%s/">%s</a>\n' $dir $dir >> index.html
  done
  printf '</pre>' >> index.html
  cp index.html $OUT
  ln -s $when $OUT/today
}

if [[ $1 == debug ]]; then
  shift
  # mkdir -p /tmp/$$
  # cd /tmp/$$
  # echo /tmp/$$
  while [[ $1 ]]; do ${=1}; shift; done
else
  trap "rm -rfv /tmp/$$" EXIT
  mkdir -p /tmp/$$
  cd /tmp/$$
  init-twitter
  fetch-timeline
  parse-timeline
  [[ -d $OUT/$when ]] && { echo "Data for today already fetched; skipping."; exit 0; }
  fetch-images $when $thread_id
  generate-album
fi
