const ETCD = '/v3/kv/';

// function asciiOnly(key) {
//   return key.replace(/[\u00A0-\uFFFF]/g,
//     ch => '\\\\u{' + ch.codePointAt(0).toString(16) + '}');
// }

/* Fetch an item from the remote K-V store, return a promise that resolves to
   the value if present or null otherwise */
function getItem(key) {
  key = encodeURI(key);
  // console.log('getItem', key);
  return fetch(ETCD+'range', {
    credentials: 'same-origin',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({key: btoa(key)}),
  }).then(function(response) {
    if (!response.ok) return Promise(null);
    return response.json()
  }).then(function(json) {
    if (!json || !json.kvs || !json.kvs[0].value) {
      return null;
    }
    return JSON.parse(decodeURI(atob(json.kvs[0].value)));
  }).catch(console.log);
}

/* Set an item in the K-V store, return a promise that resolves to the server response */
function setItem(key, value) {
  // console.log('setItem', key, value);
  return fetch(ETCD+'put', {
    credentials: 'same-origin',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      key: btoa(encodeURI(key)),
      value: btoa(encodeURI(JSON.stringify(value)))
    }),
  }).then(function(response) {
    if (!response.ok) return Promise(null);
    return response.json();
  }).catch(console.log);
}

function restoreState(recipe, bit, value) {
  let cb = document.getElementById('cb:'+bit+':'+recipe)
  cb.checked = !!value;
  findParent(cb, 'TR').classList.toggle(bit, !!value);
}

function findParent(self, tag) {
  while (self.tagName != tag) {
    self = self.parentElement;
  }
  return self;
}

function toggleState(self, bit, save=true) {
  let checked = self.checked;
  self = findParent(self, 'TR');
  let recipe = self.id;
  if (checked) {
    self.classList.add(bit);
  } else {
    self.classList.remove(bit);
  }
  let issue = findParent(self, 'TABLE').id;
  if (save) setItem(issue, buildIssueJson(issue));
}

function saveAll() {
  let tables = document.getElementsByTagName('table');
  let n=0;
  for (let table of tables) {
    let issue = table.id;
    setTimeout(_ => setItem(issue, buildIssueJson(issue)), n*100);
    n++;
  }
}

function restoreAll(_) {
  let tables = document.getElementsByTagName('table');
  let n=0;
  for (let table of tables) {
    let issue = table.id;
    setTimeout(_ => getItem(issue).then(applyIssueJson), n*100);
    n++;
  }
  setTimeout(_ => { document.getElementById('loading').classList.add('loading-done'); }, n*100);
}

function updateStarDisplay(self) {
  if (self.checked) {
    // console.log("updateDisplay:true", self);
    self.innerText = "★";
  } else {
    // console.log("updateDisplay:false", self);
    self.innerText = "☆";
  }
}

function toggleStar(self, save=true) {
  // console.log("toggleStar", self);
  self.checked = !self.checked;
  toggleState(self, 'starred', save);
  updateStarDisplay(self);
}

function clearAllStars() {
  let stars = document.querySelectorAll('tr.starred label.hotlist-button');
  for (let star of stars) {
    toggleStar(star, false);
  }
  saveAll();
}

function toggleRowFilter(filter) {
  for (let tr of document.getElementsByTagName('tr')) {
    tr.classList.toggle(filter);
  }
}

function buildIssueJson(issue) {
  let json = {};
  let rows = document.querySelectorAll('tr[id*="'+issue+'/"]');
  for (let row of rows) {
    let id = row.id;
    let recipe = {};
    recipe.cooked = document.getElementById('cb:cooked:'+id).checked;
    recipe.written = document.getElementById('cb:written:'+id).checked;
    recipe.hidden = document.getElementById('cb:hidden:'+id).checked;
    recipe.starred = document.getElementById('cb:starred:'+id).checked || false;
    json[id] = recipe;
  }
  return json;
}

function applyIssueJson(json) {
  for (let id in json) {
    let recipe = json[id];
    // console.log("applyJSON", id, recipe);
    for (let bit of ['cooked', 'written', 'hidden', 'starred']) {
      let cb = document.getElementById('cb:'+bit+':'+id);
      let row = document.getElementById(id);
      if (!cb || !row) {
        console.log("Warning: couldn't find elements for recipe: ", id);
        continue;
      }
      cb.checked = recipe[bit];
      row.classList.toggle(bit, recipe[bit]);
      if (bit == 'starred') {
        updateStarDisplay(cb);
      }
    }
  }
}

window.addEventListener('load', restoreAll);
