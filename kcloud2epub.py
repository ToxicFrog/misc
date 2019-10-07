#!/usr/bin/env python3
# Convert a Kindle Cloud Reader sqlite3 database into HTML.
# Adapted from https://github.com/d10r/kindle-fetch to run under python.
# To use, install the Kindle Cloud Reader chrome app, then go to read.amazon.com
# (or your local equivalent) and "pin and download" the books in your library
# you want to extract. The books will be written to one or more sqlite3 databases
# in ~/.config/google-chrome/Default/databases/https_read.amazon.*/; run
# kcloud2epub path/to/database/file and it'll create a directory for each
# book it finds in that database and populate it with image and HTML files.

class KindleCompression:
  # Decompression dictionary constants
  MAX_CHARACTER_LITERAL = 9983
  UNCOMPRESSED_DATA_LENGTH_ORIGIN = MAX_CHARACTER_LITERAL + 1
  MIN_DICTIONARY_KEY = UNCOMPRESSED_DATA_LENGTH_ORIGIN + 101

  # d = 9983 # MAX_CHARACTER_LITERAL
  # c = d + 1 # UNCOMPRESSED_DATA_LENGTH_ORIGIN
  # b = c + 100 + 1 # MIN_DICTIONARY_KEY
  # Used only for compression, I think
  # f = 65533
  # a = 55295
  # g = 57344
  def __init__(self, metadata):
    self.dictionary = {}
    if 'cpr' in metadata:
      print("Initializing decompressor from metadata.cpr")
      self.addStringsToDictionary(metadata['cpr'])
      self.addNumbersToDictionary()
    elif 'cprJson' in metadata:
      print("Initializing decompressor from metadata.cprJson")
      self.addStringsToDictionary(metadata['cprJson'], 256)
      self.addNumbersToDictionary(256)

  # strings is a list of strings to initialize with
  # dictionary is the existing compression dict to add to
  # n.b. this works on the COMPRESSION dictionary, i.e. it generates a mapping
  # from string to ID, not from ID to string.
  def addStringsToDictionary(self, strings, next_id=MIN_DICTIONARY_KEY):
    for k,v in self.dictionary.items():
      if v > next_id: next_id = v+1

    for string in strings:
      for length in range(2, len(string)+1):
        ss = string[0:length]
        if ss not in self.dictionary:
          self.dictionary[ss] = next_id
          next_id += 1

  # Add string representations of the numbers from 100 to 999 to the dictionary.
  def addNumbersToDictionary(self, next_id=MIN_DICTIONARY_KEY):
    numbers = [str(n) for n in range(100, 1000)]
    return self.addStringsToDictionary(numbers, next_id)

  def getDecompressionDictionary(self):
    dd = {}
    for string,token in self.dictionary.items():
      dd[token] = string
    return dd

  def expandWithStaticDictionary(self, data):
    output = []
    idx = 0
    dictionary = self.getDecompressionDictionary()
    while idx < len(data):
      token = ord(data[idx])
      idx += 1
      if token <= self.MAX_CHARACTER_LITERAL:
        output.append(chr(token))
      elif token >= self.MIN_DICTIONARY_KEY:
        output.append(dictionary[token])
      else:
        token -= self.UNCOMPRESSED_DATA_LENGTH_ORIGIN
        output.push(data[idx:idx+token])
        idx += token
    return ''.join(output)

# TODO: replace with CSS that more closely matches what the Kindle reader uses.
CSS = '''
'''

REPLACEMENTS = [
  # Replace internal links
  (r'<a href="#" onclick="KindleContentInterface\.gotoPosition\(\d+,(\d+)\); return false;" class="filepos_src" tabindex="-?\d+" id="a:.{1,4}">', '<a href="#chapter\\1" class="filepos_src">'),
  # Replace internal anchors
  (r'<a name="(\d+)" class="filepos_dest" id="a:.{1,4}">', '<a id="chapter\\1" class="filepos_dest">'),
  # Delete id=1234 fields since they aren't used in the converted file
  (r' id="(\d+)"', ''),
  # Delete k4w class since every single word has it
  (r' class="k4w"', ''),
  # Delete no-op spans
  (r'<span>([^<]+)</span>', r'\1'),
]

# <span class="k4w">was</span> <span class="k4w">quieted</span> <span class="k4w">down</span> <span class="k4w">by</span> <span class="k4w">the</span> <span class="k4w">gift</span> <span class="k4w">of</span> <span class="k4w">a</span>

HEADER = '''
  <html>
    <head>
      <style>
        body {
            margin: 0 auto;
            max-width: 50em;
            background: #FFFAFD;
            font-size:100%%;
            line-height:1.5;
        }

        img {
            max-width: 100%%;
        }

        .font-size-6 {
          font-size: 32px !important;
        }

        .font-size-4 {
          font-size: 24px !important;
        }

        .font-size-3 {
          font-size: 20px !important;
        }

        .was-a-p {
          margin-top: 0px;
          margin-bottom: 0px;
          text-indent: 2em !important;
        }

        .page-break {
          display:block;
          width:100%%;
          border-top: 3px solid #ccc;
          margin-top: 16px;
          margin-bottom: 8px;
         }
      </style>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <meta name="author" content="%s">
    </head>
    <body id="%s">
'''

import base64
import json
import os
import re
import sqlite3
import sys

db = sqlite3.connect(sys.argv[1])
c = db.cursor()

for book in c.execute('SELECT metadata FROM bookinfo'):
  metadata = json.loads(book[0])
  authors = '; '.join(metadata['authorList'])
  outdir = authors + ' -- ' + metadata['title']
  kc = KindleCompression(metadata)

  try:
    os.mkdir(outdir)
  except FileExistsError:
    pass

  print('HTML', outdir + '/index.html')
  rows = 0
  with open(outdir + '/index.html', 'w') as fd:
    fd.write(HEADER % (authors, metadata['asin']))
    for row in c.execute('''
      SELECT id,piece,other
      FROM fragments
      WHERE asin=?
      ORDER BY id
    ''', (metadata['asin'],)):
      rows += 1
      fragment = kc.expandWithStaticDictionary(row[1])
      for find,replace in REPLACEMENTS:
        fragment = re.sub(find, replace, fragment)
      imageDataMap = json.loads(row[2])['imageData'] or {}
      for image,data in imageDataMap.items():
        image = image.replace('images/', '')
        fragment = fragment.replace(
          'dataUrl="images/' + image + '"',
          'src="' + image + '"')
        print(' IMG', image)
        open(outdir + '/' + image, 'wb').write(base64.b64decode(data.replace('data:image/jpeg;base64,','')))
      fd.write(fragment)
    fd.write('</body></html>')
    print("Wrote " + str(rows) + " fragments.")
