This directory contains shell scripts for creating custom offline versions of the webcomic [Narbonic](http://narbonic.com/) by Shaenon Garrity.

**If you just want to read Narbonic right now**, there's no need for these tools; you can just head over to the website and [start reading at the beginning](http://narbonic.com/comic/july-31-august-5-2000/). (If this is your first time through, you may want to turn off commentary; spoilers abound.)

**If you want an offline, DRM-free copy of the main Narbonic storyline**, these tools will do that, but it is much faster and easier to visit the Narbonic store and buy [*Narbonic: The Perfect Collection*](https://couscouscollective.storenvy.com/collections/256382-e-books/products/1607759-complete-narbonic-perfect-collection-e-books). That gets you the complete run of Narbonic (as well as a few bonus stories) in two PDF volumes. It's also higher-quality *and* takes up less disk space than the output of these tools.

If neither of these options meet your requirements, see below.

**You already have the Perfect Collection, but wish it included the authorial commentary from Narbonic: Director's Cut.** Use `annotate-perfect-collection`, which downloads the commentary and splices it into the Perfect Collection PDFs.

**You want an offline copy of the web version, including content not part of the Perfect Collection**, such as *A Brief Moment of Culture*, *Astonishing Excursions*, and the "Dave in Slumberland" intermissions. For that, see `cbz-narbonic`.


## `annotate-perfect-collection`

This tool will automatically download all of the commentary from *Narbonic: Director's Cut*, then edit the Perfect Collection PDFs to add that commentary. You will, of course, need to already have both volumes of the Perfect Collection handy.

Compared to `cbz-narbonic` below, this:

  - runs much faster, building both volumes in about 30 minutes (on my computer) rather than taking an entire afternoon;
  - produces higher quality output (by virtue of using the high-res scans in the Perfect Collection as a starting point)
  - includes all the bonus stories from the Perfect Collection (albeit without commentary)
  - takes up much less disk space

However, it has the following caveats:

  - some quality loss occurs during the editing (hopefully not a noticeable amount, though; the results are still noticeably crisper than the web version in any case)
  - everything is in greyscale (because the Perfect Collection itself is), which means that some of the commentary refers to colour in the strips that does not appear
  - anything not included in the Perfect Collection to start with is omitted, which means most of the sunday strips -- mailbags, fanart showcases, *Atonishing Excursions*, etc


### Prerequisites

This is written for Linux, although it will probably work on Windows (via WSL or Cygwin) or OSX, if you have the right packages installed.

In addition to the Perfect Collection, you will also need the following tools:

  - `pdfimages`, `pdfseparate`, and `pdfunite` (from `poppler-utils`)
  - `identify` and `convert` (from `imagemagick`)
  - `gs` (from `ghostscript`)
  - `wkhtmltoimage`
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


## `cbz-narbonic`

This is a tool for generating an offline, comic-reader-compatible, CBZ format copy of Narbonic.

By default, it generates:

 - *Narbonic: Director's Cut*, in 13 volumes, one page per strip, with commentary
 - And separate files (with commentary) for:
   - *A Brief Moment of Culture*
   - *The Astonishing Excursions of Helen Narbon & Co*
   - *A Narbonic Colouring Book*
   - *Edie in Orbit*
   - Fanart and fan-writing showcases
   - Haiku and gerbil photography contests

Extras that don't get their own volumes (such as Shaenon's con reports, the paper dolls, etc) are located at the end of their respective main volumes.

Compared to `annotate-perfect-collection` above, it gets you all of the sunday strips, but at lower quality, and takes much longer to run.


### Prerequisites

This is written for Linux, although it will probably work on Windows (via WSL or Cygwin) or OSX, if you have the right packages installed.

You will need the following tools:
  - `wkhtmltoimage`
  - `wring`
  - the standard utilities `zip`, `curl`, `egrep`, `sed`, and `cut`

The script will check for the presence of these tools when it starts up and exit with an error message if it can't find any of them.

You will also need about 4GB of free space and several hours.


### Usage

Download this whole directory somewhere convenient and run `cbz-narbonic`.

It will (eventually) create six directories:

 - `cache`: downloaded HTML from narbonic.com
 - `img`: downloaded images from narbonic.com
 - `html`: individual generated pages, HTML format
 - `pages`: individual generated pages, JPEG or PNG format
 - `cbz`: the generated comic files
 - `music`: the Narbonic soundtrack

When it's done, everything you need should be in `cbz` and `music`. If it's interrupted halfway through, it'll pick up where it left off; similarly, if you edit the toc file, it'll regenerate only the pages that it needs to (or should; this is not well tested).

Once you're done you can delete all the intermediate files in `cache`, `img`, `html`, and `pages`, which will reclaim about 2GB of space -- but if you do that and later want to run it again, it'll have to download and generate everything all over again.


### Fine Tuning

All the configuration settings are in `narbonic.toc`. At the start you can change whether or not commentary is generated, whether each volume contains extras at the end, and what image format is used; there are further details in the comments in that file.

By rearranging the contents of the file more extensively, you can change how it's volumized, such as packing the entire main run into a single massive file, or each storyline into a separate file.
