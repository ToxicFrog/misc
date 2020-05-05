// ==UserScript==
// @name          Ubooquity Read Markers
// @namespace     https://github.com/ToxicFrog/misc
// @description   Adds unopened/in-progress/read markers to the Ubooquity comic server
// @include       https://my.ubooquity.server/comics/*
// @version       0.1
// ==/UserScript==

// Annotations are as follows
//   5 📕 Book unopened, 5 pages
// 2/5 📖 Book in progress, 2 pages of 5 read
//     ✓  Book finished
//   ? 📁 Directory status unknown
//   5 📁 Directory contains 5 unfinished books
// 2/5 📂 Directory contains 2 finished books of 5 total
//   5 ✓  All 5 books in directory finished.

// Convenience functions. filter/map work on any iterable, but are only defined as
// methods on Array for some reason.
function filter(xs, f) {
  return Array.prototype.filter.call(xs, f);
}
function map(xs, f) {
  return Array.prototype.map.call(xs, f);
}

// Ubooq isn't always served from /, so this lets us detect what the base URL is.
let baseURL = window.location.pathname.match("(/.*)/comics/[0-9]")[1];

// Fetch and display the read marker for all comics, if we're in a comic screen,
// and do nothing otherwise.
function updateAllReadStatus(_) {
  if (!document.getElementById("group")) return;
  let [_str,dirID] = window.location.pathname.match("/comics/([0-9]+)");
  let promises = map(
    document.getElementsByClassName("cell"),
    cell => {
      let img = cell.getElementsByTagName("img")[0];
      let id = img.src.match("/comics/([0-9]+)/")[1];
      return updateReadStatus(cell, id);
    });

  Promise.all(promises).then(statii => {
    // statuses is an array of booleans, true for finished, false for unfinished
    let total = statii.length;
    let read = statii.filter(x => x).length;
    console.log("Done fetching read status for directory contents, writing bookmark " + dirID + ": " + read + "/" + total);
    return saveBookmark(dirID, "" + read + "/" + total).then(_ => read == total);
  }).then(all_read => {
    // Add a button to refresh the page, for easy use on tablet, since the read-
    // markers don't always refresh reliably when you get here via "close book".
    // Do this last so that the refresh button appearing is also a visual indicator for
    // "all page mongling is complete".
    let pagelabel = document.getElementById("pagelabel");
    pagelabel.innerHTML =
      (all_read ?
        '<a href="#" onclick="markAllUnread()" style="font-size:40px;"><b>❎</b></a>'
        : '<a href="#" onclick="markAllRead()" style="font-size:40px;"><b>✅</b></a>')
      + '<a href="#" onclick="location.reload();" style="font-size:40px;"><b>🔄</b></a>'
    pagelabel.setAttribute("class", "");
  })
}

window.markAllRead = function() {
  let promises = map(
    document.getElementsByClassName("cell"),
    cell => {
      if (cell.is_book) {
        return saveBookmark(cell.document_id, String(cell.total_pages - 1));
      }
    });
  Promise.all(promises).then(_ => updateAllReadStatus());
}

window.markAllUnread = function() {
  let promises = map(
    document.getElementsByClassName("cell"),
    cell => {
      if (cell.is_book) {
        return saveBookmark(cell.document_id, "-1");
      }
    });
  Promise.all(promises).then(_ => updateAllReadStatus());
}

// Fetch and display read marker for one comic, identified by cell (the div
// containing the thumbnail for that comic) and server-side ID.
function updateReadStatus(cell, id) {
  return fetch(baseURL + "/user-api/bookmark?docId=" + id)
  .then(response => {
    if (response.status != 200) {
      if (!cell.getElementsByTagName("a")[0].onclick) {
        // Missing bookmark for directory.
        return Promise.resolve({"mark": "0/0"});
      } else {
        return Promise.resolve({"mark": "-1"});
      }
    }
    return response.json();
  }).then(json => {
    if (json.mark.match("/")) {
      // We've retrieved a folder bookmark previously stored by us; no
      // need to fetch comic details to get the total page count.
      let [_,page,total] = json.mark.match("([0-9]+)/([0-9]+)");
      return [parseInt(page), parseInt(total), null];
    } else {
      // It's a normal ubooq bookmark stored 0-indexed, we need to fetch the
      // page count separately.
      let page = parseInt(json.mark) + 1
      return fetch(baseURL + "/comicdetails/" + id).then(r => r.text()).then(text => {
        let total = parseInt(text.match("nbPages=([0-9]+)")[1]);
        return [page, total, text];
      })
    }
  }).then(args => {
    let [page,total,details] = args;
    cell.current_page = page;
    cell.total_pages = total;
    cell.document_id = id;
    if (details) {
      // It's a book.
      cell.is_book = true;
      if (page <= 0) {
        addBubble(cell, total + " 📕");
      } else if (page < total) {
        addBubble(cell, "<b>" + page + "/" + total + " 📖</b>");
      } else {
        addBubble(cell, "✓");
      }
      fixupLinks(cell, details);
    } else {
      // It's a directory.
      cell.is_book = false;
      if (page <= 0) {
        addBubble(cell, (total>0? total:"?") + " 📁");
      } else if (page < total) {
        addBubble(cell, "<b>" + page + "/" + total + " 📂</b>");
      } else {
        addBubble(cell, total + " ✓"); //✔
      }
    }
    return page == total;
  })
}

function put(url, body) {
  return fetch(url, {
    method: 'PUT',
    credentials: 'same-origin',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });
}

function saveBookmark(id, mark) {
  return put(baseURL + "/user-api/bookmark?docId=" + id,
     {docId: id,
     isBook: false,
     mark: mark,
     isFinished: false,
     lastUpdate: 1});
}

// Given the thumbnail img for a comic, and the text to put in the bubble,
// install a bubble on the thumbnail using the same mechanism as used for the
// "number of comics inside this directory" bubble.
function addBubble(cell, text) {
  for (let bubble of cell.getElementsByClassName("numberblock")) {
    bubble.parentNode.removeChild(bubble);
  }
  let div = document.createElement('div');
  div.className = "numberblock";
  div.innerHTML =
    '<div class="number read-marker"><span>' + text + '</span></div>';
  cell.append(div);
}

// Adjust the linking behaviour of the cell. Make clicking the thumbnail open
// the comic without displaying the details popup. Make clicking the comic title
// download the comic.
function fixupLinks(cell, details) {
  let a = cell.getElementsByTagName("a")[0];
  if (!a.onclick) return; // Doesn't need fixing
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

function mkExitShortcutHandler($scope, elem_id, handler, predicate) {
  let warnCount = 0;
  return function() {
    if (!predicate($scope)) return handler();
    if (warnCount > 0) { history.back(); return false; }
    warnCount++;
    let button = document.getElementById(elem_id);
    let _class = button.className;
    button.className = "ubreader-warn";
    button.style = "background-color: #f00; opacity: 0.3;";
    setTimeout(_ => {
      warnCount--;
      button.style = "";
      if (button.className == "ubreader-warn") button.className = _class;
    }, 1000);
    return handler();
  }
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
    document.getElementById("pageseekbar").value = $scope.currPageNb + 1;
    updatePageCounter($scope.currPageNb + 1);
    return _loadPage(firstCall);
  }

  // Override the next/previous page buttons to flash a warning on the first tap
  // and close the book on the second if at the start/end of the book.
  $scope.nextPage = mkExitShortcutHandler(
    $scope, "rightmenu", $scope.nextPage,
    $scope => { return $scope.currPageNb+1 == $scope.nbPages; });
  $scope.previousPage = mkExitShortcutHandler(
    $scope, "leftmenu", $scope.previousPage,
    $scope => { return $scope.currPageNb == 0; });

  // Replace the progress bar with a range input that the user can drag in
  // order to easily select a page.
  let val = $scope.currPageNb + 1;
  let max = $scope.nbPages;
  bar.innerHTML = '<input id="pageseekbar" type="range" name="page" min="1" max="'+max+'" value="'+val+'" onchange="seekPage(this.value)" oninput="updatePageCounter(this.value)">';
}

// It sometimes takes a few hundred millis after closing a book for the read
// status to update on the server, so we delay briefly before loading
// the read status.
window.addEventListener('load', _ => { setTimeout(updateAllReadStatus, 1000); });
window.addEventListener('load', installPageSeekBar);
