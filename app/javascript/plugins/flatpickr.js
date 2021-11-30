import flatpickr from "flatpickr"
import rangePlugin from "flatpickr/dist/plugins/rangePlugin"


const initFlatpickr = () => {
  const datesForm = document.getElementById('home-logo');

  if (datesForm || indexDatesForm) {
    flatpickr("#range_start", {
      plugins: [new rangePlugin({ input: "#range_end" })],
      minDate: "today",
      maxDate: new Date().fp_incr(7),
      inline: false,
      dateFormat: "Y-m-d",
      "locale": {
    "firstDayOfWeek": 1
}

    })
  }

  const indexDatesForm = document.getElementById('index_range_start');
  if (indexDatesForm) {
    flatpickr("#index_range_start", {
      plugins: [new rangePlugin({ input: "#index_range_end" })],
      minDate: "today",
      maxDate: new Date().fp_incr(7),
      inline: false,
      dateFormat: "Y-m-d",
      "locale": {
        "firstDayOfWeek": 1
      }
    })
  }


};

export { initFlatpickr };
