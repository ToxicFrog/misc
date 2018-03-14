# Narbonic CBZ compiler

This is a tool for generating an offline, comic-reader-compatible, CBZ format copy of [*Narbonic: Director's Cut*](http://narbonic.com), a webcomic by Shaenon Garrity.

**If all you are after is an offline copy of the original run of Narbonic, this tool is overkill.** You should instead head over to the Narbonic store and buy [*Narbonic: The Perfect Collection*](http://couscouscollective.storenvy.com/collections/256382-e-books/products/1607759-complete-narbonic-perfect-collection-e-books). It's in PDF format, DRM-free, and the image quality and page layout are much nicer than what this tool will generate. On top of that, it comes with two bonus stories, and will take less time to buy and download than it does for this script to run.

Where this tool *is* useful is if you want:

- An offline copy of *Narbonic: Director's Cut*, with authorial commentary for each strip (present on the website but not in The Perfect Collection);
- Offline copies of *A Brief Moment of Culture*, *The Astonishing Excursions of Helen Narbon & Co*, or other side stories and fan works, with or without commentary;
- or to customize how the comic is organized into volumes (e.g. one volume per chapter, or the entire run collected into a single massive file).

By default, it generates:

 - *Narbonic+* (i.e. *Narbonic: Director's Cut*) in 13 volumes, one page per strip, with commentary
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

`narbonic-raw.index` contains all of the pages from the website, in their original order, not grouped into volumes or anything -- this is provided mostly as a reference and starting point if you want to build a version that volumizes things very differently. If you just want to tweak the default configuration a bit, editing `narbonic.index` should be sufficient.
