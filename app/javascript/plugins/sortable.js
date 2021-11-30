import Sortable from 'sortablejs/modular/sortable.complete.esm.js';

const sortableUpdated = () => {
  const items = Array.from(document.querySelectorAll('#sortable-items li'))
  const criterias = items.map(x => x.dataset.id)
  updateResults(criterias)
}

const updateResults = (criterias) => {
  console.log(criterias)
}


const initSortable = () => {
  if (document.querySelector('#sortable-items')) {
    var el = document.getElementById('sortable-items');
    var sortable = Sortable.create(el, {
      sort: true,
      animation: 150,
      dataIdAttr: 'data-id',
      onUpdate: sortableUpdated
    });
  }
}

export { initSortable };
