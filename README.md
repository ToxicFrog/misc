# Narbonic CBZ compiler

This is a tool for generating CBZs from the webcomic Narbonic. All content is downloaded from narbonic.com as needed.

By default, it generates:

 - *Narbonic* in 13 volumes, one page per week, no commentary
 - *Narbonic: Director's Cut* (aka *Narbonic+*) in 13 volumes, one page per strip, with commentary
 - And separate files (with commentary) for:
   - *A Brief Moment of Culture*
   - *The Astonishing Excursions of Helen Narbon & Co*
   - *A Narbonic Colouring Book*
   - *Edie in Orbit*
   - Fanart and fan-writing showcases
   - Haiku and gerbil photography contests

Extras that don't go into these files (such as Shaenon's con reports, the paper dolls, etc) are located at the end of their respective main volumes.

## Generating the files.

Download `build-narbonic` and `narbonic.index` to a scratch directory, `cd` into the directory, and run `./build-narbonic`.

It will create six directories:

 - `cache`: downloaded HTML from narbonic.com
 - `img`: downloaded images from narbonic.com
 - `html`: individual generated pages, HTML format
 - `pages`: individual generated pages, JPEG or PNG format
 - `cbz`: the generated comic files
 - `music`: the Narbonic soundtrack

When it's done, everything you need should be in `cbz` and `music`. If it's interrupted halfway through, it'll pick up where it left off; similarly, if you edit the index file, it'll regenerate only the pages that it needs to (or should; this is not well tested).

Once you're done you can delete all the intermediate files in `cache`, `img`, `html`, and `pages`, which will reclaim about 2GB of space -- but if you do that and later want to run it again, it'll have to download and generate everything all over again.

## Editing the generated files

File generation is controlled by `narbonic.index`, which is actually a shell script. The contents should hopefully be self-explanatory.

`narbonic-raw.index` contains all of the pages from the website, in their original order, not grouped into volumes or anything -- this is provided mostly as a reference and starting point if you want to build a version that volumizes things differently.
