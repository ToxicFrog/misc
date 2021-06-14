This directory contains shell scripts for creating custom offline versions of the webcomic [Narbonic](http://narbonic.com/) by Shaenon K. Garrity.

**If you just want to read Narbonic right now**, there's no need for these tools; you can just head over to the website and [start reading at the beginning](http://narbonic.com/comic/july-31-august-5-2000/). (If this is your first time through, you may want to turn off commentary; spoilers abound.)

**If you want an offline, DRM-free copy of the main Narbonic storyline**, rather than using these tools, it is much faster and easier to visit the Narbonic store and buy [*Narbonic: The Perfect Collection*](https://couscouscollective.storenvy.com/collections/256382-e-books/products/1607759-complete-narbonic-perfect-collection-e-books). That gets you the complete run of Narbonic (as well as some artwork and bonus stories not found elsewhere!) in two PDF volumes. It's also higher-quality *and* takes up less disk space.

If neither of these options are what you're after, read on.

**You already have the Perfect Collection, but wish it included the authorial commentary from Narbonic: Director's Cut.** Use `annotate-perfect-collection`, which downloads the commentary and splices it into the Perfect Collection PDFs.

**You want an offline copy of the web version, including content not part of the Perfect Collection**, such as *A Brief Moment of Culture*, *Astonishing Excursions*, and the "Dave in Slumberland" intermissions. For that, see `cbz-narbonic`.


## `annotate-perfect-collection`

This tool will automatically download all of the commentary from *Narbonic: Director's Cut*, then edit the Perfect Collection PDFs to add that commentary. You will, of course, need to already have both volumes of the Perfect Collection handy.

It does not include anything not already part of the Perfect Collection, such as the non-canon Sunday strips.

No attempt is made to edit the commentary, so, for example, the commentary for some strips refers to colour that does not appear in the Perfect Collection.


### Prerequisites

This is written for Linux, although it will probably work on Windows (via WSL or Cygwin) or OSX, if you have the right packages installed.

In addition to the Perfect Collection, you will also need the following tools:

  - `pdfimages`, `pdfseparate`, and `pdfunite` (from `poppler-utils`)
  - `identify` and `convert` (from `imagemagick`)
  - `pdfcrop` (usually included in TeXlive)
  - `htmldoc`
  - `wring`
  - the standard utilities `curl`, `fgrep`, `egrep`, `sed`, and `cut`

The script will check for the presence of these tools when it starts up and exit with an error message if it can't find any of them.

It will also need about 4GB of free space to run. Most of this is taken up by temporary files that can be deleted once it's done; the edited PDFs total about 400MB.


### Usage

Download this whole directory somewhere convenient.

Put the Perfect Collection PDFs in the same directory.

Edit the settings at the start of `perfect-collection.toc`. Hopefully you won't need to change anything except `VOL1` and `VOL2` to match the names of your input PDFs (or you can rename the PDFs to match the names configured there).

Run `annotate-perfect-collection`. It will put all of its temporary files in `tmp/`; you can delete `tmp/` when it's done, although if you plan to run this multiple times (e.g. after tweaking the font settings or something), keeping it around will make later runs go noticeably faster.

When it's done, the finished PDFs will be in `out/`. Read and enjoy!


## `pdf-narbonic`

This is a tool for generating an offline, comic-reader-compatible, PDF format copy of Narbonic.

By default, it generates:

 - *Narbonic: Director's Cut*, in seven volumes, one page per week, with commentary
 - And separate files (with commentary) for:
   - *A Brief Moment of Culture*
   - *The Astonishing Excursions of Helen Narbon & Co*
   - *A Narbonic Colouring Book*
   - *Edie in Orbit*
   - Fanart and fan-writing showcases
   - Haiku and gerbil photography contests
   - other Sunday extras in seven volumes

You can also ask it to generate versions of all of the above without commentary.


### Prerequisites

This is written for Linux, although it will probably work on Windows (via WSL or Cygwin) or OSX, if you have the right packages installed.

You will need the following tools:
  - `pdfunite` (from `poppler-utils`)
  - `identify` (from `imagemagick`)
  - `pdfcrop` (usually included in TeXlive)
  - `htmldoc`
  - `wring`
  - the standard utilities `curl`, `egrep`, `sed`, and `cut`

The script will check for the presence of these tools when it starts up and exit with an error message if it can't find any of them.

It will also need about 3GB of temporary space to run, and the generated files take up about 1GB; if you want to create both Original and ~~Extra Crispy~~ Director's Cut versions, it won't need any more temporary space, but will produce 2GB of output.


### Usage

Download this whole directory somewhere convenient.

Edit the setting at the start of `narbonic.toc`; you can control whether commentary is included, whether or not to download the extras, and whether to download the music. If you want to get really into the weeds, you can edit the rest of the file to change how things are organized into volumes.

When you're ready, run `pdf-narbonic`.

All the generated files will be stored in `out/`. Intermediate files and downloaded HTML and images will be stored in `tmp/`, and can be safely deleted once it's done.

If you want both no-commentary and with-commentary versions, run it once with one setting, then edit `narbonic.toc` and run it again -- the files have different names so it won't overwrite anything.
