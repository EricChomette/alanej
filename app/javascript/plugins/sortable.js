import Sortable from 'sortablejs/modular/sortable.complete.esm.js';


const initSortable = () => {
  if (document.querySelector('#sortable-items')) {
    var el = document.getElementById('sortable-items');
    var sortable = Sortable.create(el);
  }
}

export { initSortable };
