import flatpickr from "flatpickr"
import rangePlugin from "flatpickr/dist/plugins/rangePlugin"


const initFlatpickr = () => {
  const datesForm = document.getElementById('home-logo');

  if (datesForm || indexDatesForm) {
    flatpickr("#range_start", {
      plugins: [new rangePlugin({ input: "#range_end" })],
      minDate: "today",
      inline: false,
      dateFormat: "Y-m-d",
    })
  }

  const indexDatesForm = document.getElementById('index_range_start');
  if (indexDatesForm) {
    flatpickr("#index_range_start", {
      plugins: [new rangePlugin({ input: "#index_range_end" })],
      minDate: "today",
      inline: false,
      dateFormat: "Y-m-d",
    })
  }


};

export { initFlatpickr };
