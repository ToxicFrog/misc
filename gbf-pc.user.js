// ==UserScript==
// @name        GBF PC
// @namespace   ancilla
// @match       http://game.granbluefantasy.jp/*
// @grant       none
// @run-at      document-end
// @version     1.0
// @author      ToxicFrog
// @description Enhancements for playing Granblue Fantasy on PC: viewport centering + keyboard hotkeys
// ==/UserScript==

// Viewport centering //

function centerGame() {
  let leftbar = document.getElementsByTagName("nav")[0];
  leftbar.innerHTML = "";

  let [ww,wh] = [window.innerWidth, window.innerHeight];
  if (ww/wh < 1.0) { return; }

  let zoom = document.getElementById("mobage-game-container").style.zoom;
  let gw = (320+64) * zoom;  // Game width with sidebar but without settings
  let maxgw = (320+64+320) * zoom;  // Game width with settings expanded

  leftbar.style.width = Math.min(
    (ww - gw)/2, // center the main game viewport if we can do so without breaking the settings screen
    ww - maxgw   // otherwise put it as far to the right as we can without hiding settings
  ) + "px";
}

window.addEventListener("load", centerGame, false);
window.addEventListener("resize", centerGame, false);
// centerGame();

// Utility functions for keyboard selector dispatch //

function numberButtonSelector(n) {
  return _ => chain(
    ['div.pop-usual:visible ', ''],
    [
      // Character selection, works both on the bottom pane and for targeting buffs
      'div.btn-command-character[pos=' + (n-1) + ']',
      // Ability selection
      'div.btn-ability-available:nth-child('+n+')',
      // Summon selection, once the summon panel has been opened
      'div.lis-summon.on[pos='+n+']', // or .summon-available instead of .on, not sure which is better
      // Item selection in the Heal menu
      'div.prt-select-item div.item-small img[alt='+n+']',
    ]);
}

let shortcuts = {
  // a => attack; can also use Enter
  'a': 'div.btn-attack-start.display-on',
  // s, h, c for summons, heal, and CA toggle
  's': 'div.btn-command-summon.summon-on',
  'h': 'div.prt-sub-command div.btn-temporary',
  'c': 'div.prt-sub-command div.btn-lock',
  // numbers => character, ability, or summon selection
  '1': numberButtonSelector(1),
  '2': numberButtonSelector(2),
  '3': numberButtonSelector(3),
  '4': numberButtonSelector(4),
  '5': numberButtonSelector(5), // TODO perhaps should also open summon menu
  '6': numberButtonSelector(6),
  // Arrows for next/prev
  'ArrowLeft': 'div.ico-pre',
  'ArrowRight': 'div.ico-next',
  // Enter or Spacebar activate ok/next/quest buttons, attacks in combat, or step through dialogue or in-battle hints
  // If a popup is open it prefers buttons in the popup
  'Enter': _ => chain(
    ['div.pop-usual:visible ', 'div.prt-navi:visible ', ''],
    ['div.btn-usual-ok', 'div.prt-advice', 'div.btn-result', 'div.btn-control', 'div.prt-scene-comment', 'div.btn-attack-start'],
  ),
  ' ': _ => chain(
    ['div.pop-usual:visible ', 'div.prt-advice:visible ', ''],
    ['div.btn-usual-ok', 'div.prt-advice', 'div.btn-result', 'div.btn-control', 'div.prt-scene-comment', 'div.btn-attack-start'],
  ),
  // Escape and Backspace activate cancel/back buttons, same popup behaviour as Enter.
  'Escape': _ => chain(
    ['div.pop-usual:visible ', ''],
    ['div.btn-command-back.display-on', 'div.btn-usual-cancel'],
  ),
  'Backspace': _ => chain(
    ['div.pop-usual:visible ', ''],
    ['div.btn-command-back.display-on', 'div.btn-usual-cancel'],
  ),
};

function chain(preselectors, selectors) {
  console.info("chain", preselectors, selectors);
  for (let ps of preselectors) {
    console.info("chain:", ps, '+', selectors);
    if (tap(selectors.map(s => ps + s + ":visible").join(", "))) return;
  }
}

function tap(selector) {
  let elems = $(selector);
  console.info(selector, '=>', elems);
  if (elems.length != 1) {
    console.info("Warning:", elems.length, "elements returned from selector", selector);
    return false;
  }
  let evt = document.createEvent('Events');
  evt.initEvent('tap', true, false);g
  elems[0].dispatchEvent(evt);
  return true;
}

function keyboardEventHandler(evt) {
  let handler = shortcuts[evt.key];
  if (typeof(handler) == "function") {
    return handler();
  }
  if (typeof(handler) == "object") {
    return tap(handler.map(s => s + ":visible").join(", "));
  }
  if (typeof(handler) == "string") {
    return tap(handler + ":visible");
  }
}

document.addEventListener("keydown", keyboardEventHandler, false);
