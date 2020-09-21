const ETCD = '/v3/kv/';

/* Fetch an item from the remote K-V store, return a promise that resolves to
   the value if present or null otherwise */
function getItem(key) {
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
      console.log("getItem", key, "null");
      return null;
    }
    console.log("getItem", key, atob(json.kvs[0].value));
    return atob(json.kvs[0].value);
  })
}

/* Set an item in the K-V store, return a promise that resolves to the server response */
function setItem(key, value) {
  console.log("setItem", key, value);
  return fetch(ETCD+'put', {
    credentials: 'same-origin',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({key: btoa(key), value: btoa(value)}),
  }).then(function(response) {
    if (!response.ok) return Promise(null);
    return response.json();
  })
}

function restoreState(recipe, bit, value) {
  let cb = document.getElementById('cb:'+bit+':'+recipe)
  cb.checked = !!value;
  cb.onchange();
}

function toggleState(self, bit) {
  // Find the enclosing <tr>
  let checked = self.checked;
  while (self.tagName != "TR") {
    self = self.parentElement;
  }
  let recipe = self.id;
  if (checked) {
    setItem(recipe + "/" + bit, "yes")
    self.classList.add(bit);
  } else {
    setItem(recipe + "/" + bit, "");
    self.classList.remove(bit);
  }
}

function restoreAll(_) {
  let rows = document.querySelectorAll('tr.recipe-row');
  for (let row of rows) {
    let recipe = row.id;
    getItem(recipe+'/written').then(v => restoreState(recipe, 'written', v));
    getItem(recipe+'/cooked').then(v => restoreState(recipe, 'cooked', v));
    getItem(recipe+'/hidden').then(v => restoreState(recipe, 'hidden', v));
  }
}

function toggleStar(self) {
  if (self.innerText == "★") {
    self.innerText = "☆";
  } else {
    self.innerText = "★";
  }
}

window.addEventListener('load', restoreAll);
