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

## Editing the generated files

File generation is controlled by `volumes.index`, which uses a fairly simple format:

 - `# Volume Name` starts a new volume
 - `## Chapter Name` starts a new chapter (and emits a splash page for it)
 - `### Extras` starts an extras section (emits a splash screen, commentary is always included)
 - `<id> <title>` tells it to download a page titled `<title>` from `http://narbonic.com/comic/<id>`

TODO: volumes.index should also control which books have or have not commentary, so that we can just run transform-html once and it'll emit Narbonic and Narbonic+ in one pass and everything will be wonderful.
