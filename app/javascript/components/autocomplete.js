const places = require("places.js")

const initAutocomplete = () => {
  if (document.querySelector('#query_city')) {
    var placesAutocomplete = places({
      appId: "plKLD0BHQSLV",
      apiKey: "2beec28782dce9d19be43046ba53dd6f",
      container: document.querySelector('#query_city')
    });
  }

  if (document.querySelector('#index_query_city')) {
    var placesAutocomplete = places({
      appId: "plKLD0BHQSLV",
      apiKey: "2beec28782dce9d19be43046ba53dd6f",
      container: document.querySelector('#index_query_city')
    });
  }
}

export { initAutocomplete };
