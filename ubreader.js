// ==UserScript==
// @name          Ubooquity Read Markers
// @namespace     https://github.com/ToxicFrog/misc
// @description   Adds unopened/in-progress/read markers to the Ubooquity comic server
// @include       https://my.ubooquity.server/comics/*
// @version       0.1
// ==/UserScript==

// Ubooq isn't always served from /, so this lets us detect what the base URL is.
let baseURL = window.location.pathname.match("(/.*)/comics/[0-9]+")[1];

// Convenience function. map() works on any iterable, but is only defined as
// a method on Array for some reason.
function map(xs, f) {
  return Array.prototype.map.call(xs, f);
}

// Fetch and display the read marker for all comics, if we're in a comic screen,
// and do nothing otherwise.
function updateAllReadStatus(_) {
  let cells = document.getElementsByClassName("cell");
  if (cells.length == 0 || !cells[0].getElementsByTagName("a")[0].onclick) {
    // Not in a comic screen.
    return;
  }

  for (let cell of cells) {
    let img = cell.getElementsByTagName("img")[0];
    let id = img.src.match("/comics/([0-9]+)/")[1];
    updateReadStatus(baseURL, cell, id);
  }
}

// Fetch and display read marker for one comic, identified by cell (the div
// containing the thumbnail for that comic) and server-side ID.
function updateReadStatus(baseURL, cell, id) {
  fetch(baseURL + "/user-api/bookmark?docId=" + id)
  .then(response => {
    if (response.status != 200) {
      return Promise.reject("no bookmark");
    }
    return response.json();
  }).then(json => {
    cell.bookmark = parseInt(json.mark) + 1;
    return fetch(baseURL + "/comicdetails/" + id);
  }).then(response => {
    return response.text();
  }).then(text => {
    let pages = parseInt(text.match("nbPages=([0-9]+)")[1]);
    if (pages != cell.bookmark) {
      addBubble(cell, cell.bookmark + "/" + pages + " 📖");
    }
  }).catch(err => {
    addBubble(cell, "📕");
  });
}

// Given the thumbnail img for a comic, and the text to put in the bubble,
// install a bubble on the thumbnail using the same mechanism as used for the
// "number of comics inside this directory" bubble.
function addBubble(cell, text) {
  let div = document.createElement('div');
  div.className = "numberblock";
  div.innerHTML =
    '<div class="number read-marker"><span>' + text + '</span></div>';
  cell.append(div);
}

window.addEventListener('load', updateAllReadStatus);
