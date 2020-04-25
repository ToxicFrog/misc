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
  let leftbar = $("nav")[0];
  leftbar.innerHTML = "";

  let [ww,wh] = [window.innerWidth, window.innerHeight];
  if (ww/wh < 1.0) { return; }

  let zoom = $("#mobage-game-container")[0].style.zoom;
  let gw = (320+64) * zoom;  // Game width with sidebar but without settings
  let maxgw = (320+64+320) * zoom;  // Game width with settings expanded

  leftbar.style.width = Math.min(
    (ww - gw)/2, // center the main game viewport if we can do so without breaking the settings screen
    ww - maxgw   // otherwise put it as far to the right as we can without hiding settings
  ) + "px";
}

function tryCenterGame() {
  try {
    if (document.getElementsByTagName('nav')[0]) {
      centerGame();
    } else {
      setTimeout(tryCenterGame, 100);
    }
  } catch(e) { console.info(e); }
}

window.addEventListener("load", centerGame, false);
window.addEventListener("resize", centerGame, false);
tryCenterGame();


// Utility functions for keyboard mapping table //

// Return a selector that matches any of its arguments, with :visible appended to them.
function AnyOf() {
  return Array.prototype.map.call(
    arguments, x => `${x}:visible`
  ).join(', ');
}

// Return a selector that matches any xs (with :visible) inside p.
function Cond(p, xs) {
  return Array.prototype.map.call(
    xs, x => `${p} ${x}:visible`
  ).join(', ');
}

function Go(hash) {
  return _ => { window.location.hash = `#${hash}`; }
}

function NumberButtonSelector(n) {
  return [
    // Character or item selection in popup
    Cond('div.pop-usual',
         [`div.btn-command-character[pos=${n-1}]`, `div.prt-select-item div.lis-item:nth-child(${n})`]),
    AnyOf(
      // Character selection outside popup
      `div.btn-command-character[pos=${n-1}]`,
      // Ability selection
      `div.btn-ability-available:nth-child(${n})`,
      // Summon selection, once the summon panel has been opened
      `div.prt-summon-list.opened > div.lis-summon.on[pos=${n}]`, // or .summon-available instead of .on, not sure which is better
    ),
  ];
}

// Mapping of shortcut keys to selectors for controls they should activate.
// Keys are the KeyEvent.key value.
// Values:
// - if a string containing a single selector (no ,), has :visible appended and then used
// - if a string containing multiple ,-separated selectors, used without modification
// - if a function, it's called
// - if a list, each element is evaluated in order using these rules; evaluation stops when
//   one element succeeds
// In any case, if the selector evaluates to exactly one element, that element is activated.

// Selectors for dialogue or splash screens where advancing them is "safe", i.e.
// you won't be inadvertently agreeing to or cancelling something.
let dialogueOrSplashScreen = AnyOf(
  'div.prt-advice', 'div.prt-scene-comment', 'div.btn-result',
  'canvas#cjs-gacha', 'canvas#cjs-login', 'canvas#cjs-panel-mission',
  //'div.cnt-quest',
);
let shortcuts = {
  // s, h, c for summons, heal, and CA toggle
  's': 'div.prt-summon-list > div.prt-list-top.btn-command-summon',
  'h': 'div.prt-sub-command div.btn-temporary',
  'c': 'div.prt-sub-command div.btn-lock',
  // QAZ to target enemies
  'q': 'a.btn-targeting.enemy-1',
  // This isn't a typo; enemies 1 and 2 are always the top and bottom ones respectively,
  // so if you're fighting 3 enemies, #3 goes in the middle.
  // 'a' can also be used to attack, or autoselect in the upgrade screen.
  'a': AnyOf('a.btn-targeting.enemy-3', 'div.btn-attack-start.display-on', 'div.btn-recommend'),
  'z': 'a.btn-targeting.enemy-2',
  // numbers => character, ability, or summon selection
  '1': NumberButtonSelector(1),
  '2': NumberButtonSelector(2),
  '3': NumberButtonSelector(3),
  '4': NumberButtonSelector(4),
  '5': NumberButtonSelector(5), // TODO perhaps should also open summon menu
  '6': NumberButtonSelector(6),
  // Arrows for next/prev
  'ArrowLeft': 'div.ico-pre', // btn-prev-job btn-next-job
  'ArrowRight': 'div.ico-next',
  // Enter activates ok/next/quest buttons, attacks in combat, or steps through dialogue or in-battle hints
  // If a popup is open it prefers buttons in the popup
  'Enter': [
    // If a popup is open prefer that
    'div.pop-usual div.btn-usual-ok',
    'div.pop-usual div.btn-usual-close',
    // Otherwise step through dialogue
    dialogueOrSplashScreen,
    // If no popup or dialogue, look for any sort of OK/next screen/attack button and activate it.
    AnyOf('div.btn-usual-ok', 'div.btn-usual-close',
          'div.btn-lupi.multi', // 10 part rupie gacha
          'div.btn-synthesis', 'div.btn-evolution', // upgrade and uncap
          // TODO: investigate other stuff in .prt-button-area:
          //.btn-{unclaimed,retry,continue,retry-sequence}
          'div.prt-button-area.upper div.btn-control',
          'div.btn-attack-start.display-on'),
  ],
  // Spacebar advances dialogue but doesn't activate buttons or attack.
  ' ': dialogueOrSplashScreen,
  // Escape and Backspace activate cancel/back buttons, same popup behaviour as Enter.
  'Escape': [
    Cond('div.pop-usual', ['div.btn-command-back.display-on', 'div.btn-usual-cancel', 'div.btn-usual-close']),
    AnyOf('div.btn-command-back.display-on', 'div.btn-usual-cancel'),
  ],
  'Backspace': [
    Cond('div.pop-usual', ['div.btn-command-back.display-on', 'div.btn-usual-cancel', 'div.btn-usual-close']),
    AnyOf('div.btn-command-back.display-on', 'div.btn-usual-cancel'),
    'div.lis-lead-prev',
  ],
  'alt-w': Go('quest/island'),
  'alt-q': Go('quest'),
  'alt-h': Go('mypage'),
  'alt-d': Go('gacha'),
  'alt-p': Go('party/index/0/npc/0'),
  'alt-u': Go('enhancement/weapon/base'), // or npc or summon; replace enhancement with evolution for uncapping
  'alt-i': Go('list'), // inventory
  'alt-c': Go('present'), // crate
  'alt-j': Go('archive/top'), // journal
};

// Given a selector or selector tree from the keymap, try to turn it into a control and activate it
function trySelector(selector) {
  // console.info("trySelector:", selector);
  if (typeof(selector) == "string") {
    if (selector.indexOf(',') == -1) {
      // Single selector
      return tap(selector + ":visible");
    } else {
      // Multiple selectors
      return tap(selector);
    }
  }
  if (typeof(selector) == "function") {
    return selector();
  }
  if (typeof(selector) == "object") {
    for (let s of selector) {
      if (trySelector(s)) return true;
    }
  }
  return false;
}

// Given a CSS selector, resolve it and tap the result iff it resolves to exactly 1 element
// returns true if a single element was found and tapped, false otherwise
function tap(selector) {
  let elems = $(selector);
  // console.info(selector, '=>', elems);
  if (elems.length != 1) {
    if (elems.length > 1) console.info("Warning:", elems.length, "elements returned from selector", selector);
    return false;
  }
  let elem = elems[0];
  if (elem.tagName == "CANVAS") {
    // Special handling for <canvas> tags -- we can't just send them a "tap" event,
    // we need to actually send separate "touchstart" and "touchend" events with
    // valid coordinates inside the canvas's bounding rect.
    let r = elem.getBoundingClientRect();
    let t = new Touch({
      identifier: 1, target: elem,
      force: 1, radiusX: 1, radiusY: 1,
      pageX: r.x + r.width/2, pageY: r.y + r.height/2,
    })
    let options = {bubbles: true, changedTouches: [t], targetTouches: [t], touches: [t]};
    elem.dispatchEvent(new TouchEvent("touchstart", options));
    elem.dispatchEvent(new TouchEvent("touchend", options));
  } else {
    elem.dispatchEvent(new UIEvent("tap", {bubbles: true}));
  }
  return true;
}

function keyboardEventHandler(evt) {
  try {
    let key = evt.key;
    if (evt.metaKey) key = "meta-" + key;
    if (evt.altKey) key = "alt-" + key;
    if (evt.ctrlKey) key = "ctrl-" + key;
    let selector = shortcuts[key];
    if (selector) {
      console.info(key, ' => ', selector);
      evt.preventDefault();
      trySelector(selector);
    }
  } catch(e) {
    console.info(e);
  }
}

document.addEventListener("keydown", keyboardEventHandler, false);
