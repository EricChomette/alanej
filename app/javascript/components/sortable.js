
const initSortable = () => {
  if (document.querySelector('#container-horizontal')) {
    $('#container-horizontal .item').sortable({
      flow: 'horizontal',
      wrapPadding: [10, 10, 0, 0],
      elMargin: [0, 0, 10, 10],
      elHeight: 'auto',
      filter: function (index) { return index !== 2; },
      timeout: 1000
    });
  }
}

export { initSortable };
