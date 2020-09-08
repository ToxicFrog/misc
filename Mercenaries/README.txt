# Mercenaries - Playground of Destruction
# All Subtitles for All Characters Patch

This patch enables all subtitles for all three playable characters, regardless
of language. This enables you to play through the game once with your favourite
character while still understanding all the dialogue -- whether in Chinese,
Russian, Korean, or English -- rather than just the languages your chosen
character understands.

It doesn't add subtitles for dialogue that doesn't have them for any character,
such as combat barks from NPCs -- only lines that have subtitles for at least
one character already are affected.

## Applying the Patch

The patch is in PPF3 format, so you should be able to use any modern PPF patcher
like `applyppf3` or `PPF-O-Matic` to apply it to your ISO. Note that the patch
is for the original North American release of the game, with the following
characteristics:

  File: Mercenaries - Playground of Destruction
  Format: ISO
  Region: NTSC-U
  Serial: SLUS-20932
  MD5: f91736e5512c3980e493a5c75e59d2da
  SHA1: 80285a6741e2680af2f70e3c34e6b5d4d1ef3078

It is completely untested on (and probably will not work on) any other version,
including the PAL and NTSC-J and the NTSC-U "Greatest Hits" release. If you want
to generate a patch for one of these releases and have the ISO handy, see below.


## Generating a New Patch

The script `subtitles.lua` included in this archive was used to generate the
original patch. If you have a different release of Mercenaries, you can use it
to generate a patched version of your release, and then use a tool such as
`makeppf3` to compare that to the original ISO and produce a PPF.

Read the comments at the start of the script for details.


## Technical Details

English subtitles are stored in `DATAPS2/ENGLISH.DSK`, which looks like a table
mapping localization IDs (short ASCII strings) to the localized strings (UTF-16
text) -- this includes not just subtitles but item names, UI elements, and so
forth. (I haven't tried to figure out the whole file format but it's pretty easy
to navigate in a hex editor.)

Subtitles may be prefixed with `{k}`, `{r}`, or `{c}` (in UTF-16, of course) to
denote that the corresponding spoken line is in Korean, Russian, or Chinese,
respectively. If one of these tags is present, the game only displays the
subtitle if you're playing as a character who can understand that language.

The patch works by replacing these tags with spaces, causing the game to display
them unconditionally. It even ignores leading whitespace in subtitles, so there
are no display glitches!
