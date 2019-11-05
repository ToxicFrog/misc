// ==UserScript==
// @name          Ubooquity Read Markers
// @namespace     https://github.com/ToxicFrog/misc
// @description   Adds unopened/in-progress/read markers to the Ubooquity comic server
// @include       https://my.ubooquity.server/comics/*
// @version       0.1
// ==/UserScript==

// Convenience function. map() works on any iterable, but is only defined as
// a method on Array for some reason.
function filter(xs, f) {
  return Array.prototype.filter.call(xs, f);
}

// Fetch and display the read marker for all comics, if we're in a comic screen,
// and do nothing otherwise.
function updateAllReadStatus(_) {
  if (!document.getElementById("group")) return;
  // Ubooq isn't always served from /, so this lets us detect what the base URL is.
  let baseURL = window.location.pathname.match("(/.*)/comics/[0-9]+")[1];
  let cells = filter(
    document.getElementsByClassName("cell"),
    cell => { return !!cell.getElementsByTagName("a")[0].onclick; });
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
      return Promise.resolve({"mark": "-1"});
    }
    return response.json();
  }).then(json => {
    cell.bookmark = parseInt(json.mark) + 1;
    return fetch(baseURL + "/comicdetails/" + id);
  }).then(response => {
    return response.text();
  }).then(text => {
    let pages = parseInt(text.match("nbPages=([0-9]+)")[1]);
    if (cell.bookmark <= 0) {
      addBubble(cell, "📕");
    } else if (pages != cell.bookmark) {
      addBubble(cell, cell.bookmark + "/" + pages + " 📖");
    }
    fixupLinks(baseURL, cell, text);
  })
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

// Adjust the linking behaviour of the cell. Make clicking the thumbnail open
// the comic without displaying the details popup. Make clicking the comic title
// download the comic.
function fixupLinks(baseURL, cell, details) {
  let a = cell.getElementsByTagName("a")[0];
  let reader_url = details.match('/comicreader/reader.html[^"]+')[0];
  a.onclick = null;
  a.href = baseURL + reader_url.replace(/&amp;/g, "&");
  let download_url = details.match('href="([^"]*/comics/[0-9]+/[^"]+cb[zrta])"')[1];
  let label = cell.getElementsByClassName("label")[0];
  label.innerHTML = '<a style="color:#ADF;" href="' + download_url + '">' + label.innerText + '</a>';
}

// Stuff for the better seek bar.

function seekPage(page) {
  let _prompt = window.prompt;
  window.prompt = _ => page;
  document.getElementById("gotobutton").click();
  window.prompt = _prompt;
}

function showPage(page) {
  let label = document.getElementById("pagelabel");
  let bar = document.getElementById("progressbar");
  label.innerText = "Page " + page + " of " + bar.max;
}

function installPageSeekBar(_) {
  let bar = document.getElementById("progressbar");
  console.log(bar.firstElementChild);
  console.log(document.getElementById("pagelabel"));
  if (!bar) return;
  let val = bar.firstElementChild.getAttribute("aria-valuenow");
  bar.max = bar.firstElementChild.getAttribute("aria-valuemax");
  bar.innerHTML = '<input type="range" name="page" min="1" max="'+bar.max+'" value="'+val+'" onchange="seekPage(this.value)" oninput="showPage(this.value)">';
}

window.addEventListener('load', updateAllReadStatus);
window.addEventListener('load', installPageSeekBar);
