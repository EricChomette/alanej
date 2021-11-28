import flatpickr from "flatpickr"
import rangePlugin from "flatpickr/dist/plugins/rangePlugin"


const initFlatpickr = () => {
  const datesForm = document.getElementById('home-logo');
  if (datesForm) {
    flatpickr("#range_start", {
      plugins: [new rangePlugin({ input: "#range_end" })],
      minDate: "today",
      inline: false,
      dateFormat: "Y-m-d",
    })
  }
};

export { initFlatpickr };
