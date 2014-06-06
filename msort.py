#!/usr/bin/python2

from __future__ import print_function

import re
import sys
import os

from string import Formatter

from mutagen.id3 import ID3NoHeaderError
from mutagen.easyid3 import EasyID3

from music import findMusic
from args import parser, subparsers

def utf8(str):
  if isinstance(str, unicode):
    return str
  return unicode(str, 'utf-8')

options = None
subparser = parser.add_subcommand('sort',
  help='organize files based on tags',
  description="""
    The --file-name and --dir-name arguments can contain {tags}. These will be taken from the
    file being sorted.

    If a {tag} ends with ?, it will be treated as "" if missing. Otherwise, if it encounters a
    file missing that tag, it will report an error and exit.

    If a {tag} contains slashes, it will split it on those and then take the first one it
    finds; e.g. {artist/composer} will be replaced with the artist if the file has that tag,
    and the composer otherwise, and fail if the file has neither.

    It is recommended that you run first with --dry-run (the default). Use --no-dry-run to
    actually move the files.
  """)

subparser.add_argument('paths', type=utf8, nargs='*', default=[u"."],
  help='paths to search for music files in, default %(default)s')
subparser.add_argument('--library', type=utf8,
  help='path to music library',
  default=os.path.join(os.getenv('HOME'), 'Music'))
subparser.add_argument('--dir-name', type=utf8,
  help='pattern for destination directory; default %(default)s',
  default='{library}/{genre}/{category?}/{group/artist/composer/performer}/{album}')
subparser.add_argument('--safe-paths', type=utf8,
  help='replace characters not normally allowed in filenames',
  default='linux')
subparser.add_argument('--safe-char', type=utf8,
  help='replace characters removed by --safe-paths with this',
  default='-')
subparser.add_flag('dry-run', True,
  help='report only, do not actually move any files')
subparser.add_flag('dirs-only', False,
  help='create destination directories but do not move any files')

sp_group = subparser.add_mutually_exclusive_group()
sp_group.add_argument('--file-name', type=utf8,
  help='pattern for destination files; default %(default)s',
  default='{title}')
sp_group.add_argument('--prefix-track',
  help='as --file-name="%(const)s"',
  action='store_const', dest='file_name', const='{disc?}{track!d:02d} - {title}')
sp_group.add_argument('--prefix-artist',
  help='as --file-name="%(const)s"',
  action='store_const', dest='file_name', const='{artist} - {title}')
sp_group.add_argument('--prefix-both',
  help='enables both --prefix-track and --prefix-artist',
  action='store_const', dest='file_name', const='{disc?}{track!d:02d} - {artist} - {title}')

class MusicPathFormatter(Formatter):
  _conversions = {
    'd': int,
    'f': float,
  }

  def __init__(self, tags):
    self._tags = tags

  def get_value(self, key, args, kwargs):
    optional = False
    if '/' in key:
      for subkey in key.split('/'):
        try:
          return self.get_value(subkey, args, kwargs)
        except:
          pass
      raise KeyError(key)
    if key.endswith('?'):
      key = key[:-1]
      optional = True
    if key in kwargs:
      return kwargs[key]
    if hasattr(self._tags, key):
      return getattr(self._tags, key)
    if optional:
      return ''
    raise KeyError(key)

  def convert_field(self, value, conversion):
    if conversion in self._conversions:
      return self._conversions[conversion](value)
    return super(MusicPathFormatter, self).convert_field(value, conversion)


def newPath(tags):
  (_, ext) = os.path.splitext(tags.file)
  template = os.path.join(options.dir_name, options.file_name) + ext

  return MusicPathFormatter(tags).format(
    template,
    library=options.library)


dirs = set()
def mkDirFor(file):
  dir = os.path.dirname(file)
  if dir in dirs:
    return
  print(dir)
  dirs.add(dir)
  if not options.dry_run and not os.path.exists(dir):
    os.makedirs(dir)


def moveFile(src, dst):
  print('\t%s' % os.path.basename(dst))
  if not options.dry_run:
    os.rename(src, dst)


def main(_options):
  global options
  options = _options

  for i,tags in enumerate(sorted(findMusic(options.paths), key=lambda x: x.file)):
    try:
      dst = newPath(tags)
      mkDirFor(dst)
      if not options.dirs_only:
        moveFile(tags.file, dst)
    except KeyError as e:
     print("Error sorting file '%s': missing tag %s" % (tags.file, e))
    except OSError as e:
      print("Error sorting file '%s': %s" % (tags.file, e))

subparser.set_defaults(func=main)
if __name__ == '__main__':
  main(parser.parse_args())

