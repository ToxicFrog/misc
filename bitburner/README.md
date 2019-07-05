These are my scripts for [BitBurner](https://danielyxie.github.io/bitburner/).

You may note that they are mostly written in Lua, not NetScript/JavaScript. At some point I'll do a detailed blog post on how this works. The short answer is: it uses [Fengari](https://fengari.io/), which I highly recommend if you need to run Lua in the browser.

There's a mix of one-shot utilities and long-running daemons in here, and *most* of them should at least have a comment explaining what they do at the top, and sometimes some editable settings. The tl;dr on how to load and run them is below.

## I want to download/run all the stuff in this repo

Download `fetch.ns`. Run it, and it'll automatically download the rest and compile all the Lua scripts. Then run `/bin/init.ns` to run the Lua installer and start up the daemons. The `.lua` files get downloaded to `.lua.txt` and then compiled to `.L.ns` scripts you can run directly.

If you want to run your own fork, just put it somewhere with a web server and edit `fetch.ns` to point to your new URL.

## I just want to run my own Lua scripts

Download `bin/lua-installer.ns`, `lib/lua.ns` and `bin/luac.ns`. Run `lua-installer.ns` after each page refresh. To write scripts in Lua, write a `.lua.txt` file in bitburner and run `luac.ns` on it. You'll get a `.L.ns` file you can run directly.

Notes:

- Netscript functions are available in the global `ns`, and Fengari interop functions in the global `js`. All the standard lua libraries are loaded except those which are not available in Fengari.
- `ns` functions (and all other Javascript functions) must be called as methods, e.g. `ns:ls()` or `ns.codingcontract:attempt()`. `luac` will attempt to warn you if you get it wrong.
- All async `ns` functions have been wrapped in `coroutine.yield()` calls, and the entire program runs inside a coroutine, so you can simply call them normally and your program will be suspended until they complete. More generally, anytime you have a JS `Promise` you can `yield()` it and when your program is resumed you'll get back whatever the `Promise` evaluated to.

