// ==UserScript==
// @name          Ubooquity Read Markers
// @namespace     https://github.com/ToxicFrog/misc
// @description   Adds unopened/in-progress/read markers to the Ubooquity comic server
// @include       https://my.ubooquity.server/comics/*
// @version       0.1
// ==/UserScript==

// Convenience function. filter() works on any iterable, but is only defined as
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
    // Only actual comics have an onclick handler on the <a>, directories
    // just have a direct link to the dir page
    cell => { return !!cell.getElementsByTagName("a")[0].onclick; });
  for (let cell of cells) {
    let img = cell.getElementsByTagName("img")[0];
    let id = img.src.match("/comics/([0-9]+)/")[1];
    updateReadStatus(baseURL, cell, id);
  }

  // Add a button to refresh the page, for easy use on tablet, since the read-
  // markers don't naturally refresh when you get here via "close book".
  let pagelabel = document.getElementById("pagelabel");
  pagelabel.innerHTML = '<a href="#" onclick="location.reload();" style="font-size:40px;"><b>&#128260;</b></a>'
  pagelabel.setAttribute("class", "");
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

function getScope() {
  return angular.element(document.querySelector("#pagelabel")).scope();
}

// Seek to the given page. Called by the seek slider when it's released.
function seekPage(page) {
  let $scope = getScope();
  let oldpage = $scope.currPageNb + 1
  if (page == oldpage) return;
  $scope.currentWay = page > oldpage ? $scope.WAY.FORWARD : $scope.WAY.BACKWARD;
  $scope.currPageNb = page - 1;
  $scope.loadPage(false);
}

// Change the "page X of Y" counter to reflect the position of the slider.
// Called when the slider is dragged, and also when our loadPage() wrapper is
// called, since the code in ubooq that's meant to keep updating it sometimes
// breaks.
function updatePageCounter(page) {
  document.getElementById("pagelabel").innerText =
    "Page " + page + " of " + getScope().nbPages;
}

// Initial setup for the improved page seek bar.
function installPageSeekBar(_) {
  let bar = document.getElementById("progressbar");
  if (!bar) return; // Not currently reading a book.

  // Install a wrapper around $scope.loadPage() that properly updates the
  // page counter and seek bar. This is called every time a new page is
  // loaded, so it should keep things in sync...
  let $scope = getScope();
  let _loadPage = $scope.loadPage;
  $scope.loadPage = function(firstCall) {
    let $scope = getScope();
    document.getElementById("pageseekbar").value = $scope.currPageNb + 1;
    updatePageCounter($scope.currPageNb + 1);
    return _loadPage(firstCall);
  }

  // Replace the progress bar with a range input that the user can drag in
  // order to easily select a page.
  let val = $scope.currPageNb + 1;
  let max = $scope.nbPages;
  bar.max = bar.firstElementChild.getAttribute("aria-valuemax");
  console.log(val);
  bar.innerHTML = '<input id="pageseekbar" type="range" name="page" min="1" max="'+bar.max+'" value="'+val+'" onchange="seekPage(this.value)" oninput="updatePageCounter(this.value)">';
}

// It sometimes takes a few hundred millis after closing a book for the read
// status to update on the server, so we delay briefly before loading
// the read status.
window.addEventListener('load', _ => { setTimeout(updateAllReadStatus, 1000); });
window.addEventListener('load', installPageSeekBar);
