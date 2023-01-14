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
  // console.log('putItem', key, value);
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

function toggleState(self, bit) {
  let checked = self.checked;
  self = findParent(self, 'TR');
  let recipe = self.id;
  if (checked) {
    // setItem(recipe + "/" + bit, "yes");
    self.classList.add(bit);
  } else {
    // setItem(recipe + "/" + bit, "");
    self.classList.remove(bit);
  }
  let issue = findParent(self, 'TABLE').id;
  setItem(issue, buildIssueJson(issue));
}

function restoreAll(_) {
  let tables = document.getElementsByTagName('table');
  let n=0;
  for (table of tables) {
    let issue = table.id;
    setTimeout(_ => getItem(issue).then(applyIssueJson), n*100);
    n++;
  }
  setTimeout(_ => { document.getElementById('loading').classList.add('loading-done'); }, n*100);
}

function toggleStar(self) {
  if (self.innerText == "★") {
    self.innerText = "☆";
    findParent(self, 'TR').classList.remove('starred');
  } else {
    self.innerText = "★";
    findParent(self, 'TR').classList.add('starred');
  }
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
    json[id] = recipe;
  }
  return json;
}

function applyIssueJson(json) {
  for (let id in json) {
    let recipe = json[id];
    for (let bit of ['cooked', 'written', 'hidden']) {
      let cb = document.getElementById('cb:'+bit+':'+id);
      let row = document.getElementById(id);
      if (!cb || !row) {
        console.log("Warning: couldn't find elements for recipe: ", id);
        continue;
      }
      cb.checked = recipe[bit];
      row.classList.toggle(bit, recipe[bit]);
    }
  }
}

window.addEventListener('load', restoreAll);
