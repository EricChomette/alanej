import Sortable from 'sortablejs/modular/sortable.complete.esm.js';

const sortableUpdated = () => {
  const items = Array.from(document.querySelectorAll('#sortable-items li'))
  const criterias = items.map(x => x.dataset.id)
  const criteriasInput = document.querySelector("#query_criterias")
  if (criteriasInput) {
    criteriasInput.value = criterias.join(",")
  }
  // storeCriterias(criterias)
}

// function storeCriterias(criterias) {
//   const csrfToken = document.querySelector("[name='csrf-token']").content

//   const url = `http://localhost:3000/stations/index-recup`;
//   console.log(criterias);
//   fetch(url, {
//     method: 'POST',
//     headers: {
//       "X-CSRF-Token": csrfToken,
//       'Accept': 'application/json',
//       'Content-Type': 'application/json'
//     },
//     body: JSON.stringify({ tab: criterias })
//   });
// }

const initSortable = () => {
  if (document.querySelector('#sortable-items'||'#home-sortable-items')) {
    var el = document.getElementById('sortable-items' || 'home-sortable-items');
    var sortable = Sortable.create(el, {
      sort: true,
      animation: 150,
      dataIdAttr: 'data-id',
      onUpdate: sortableUpdated
    });
  }
}

export { initSortable };
