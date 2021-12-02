
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

let map;
const element = document.createElement('div');
        element.className = 'marker';
        element.style.backgroundImage = `url('https://zupimages.net/up/21/48/rztt.png')`;
        element.style.backgroundSize = 'contain';
        element.style.width = '37px';
        element.style.height = '37px';
const element2 = document.createElement('div');
        element2.className = 'marker';
        element2.style.backgroundImage = `url('https://zupimages.net/up/21/48/bw4s.png')`;
        element2.style.backgroundSize = 'contain';
        element2.style.width = '37px';
        element2.style.height = '37px';     
const addItinerary = (start, end) => {


  const url = `https://api.mapbox.com/directions/v5/mapbox/cycling/${start.lng},${start.lat};${end.lng},${end.lat}?steps=true&geometries=geojson&access_token=${mapboxgl.accessToken}`


  fetch(url, { method: 'GET' })
    .then(x => x.json())
    .then((data) => {
     
      const coordinates = data.routes[0].geometry.coordinates
      const geojson = {
        'type': 'Feature',
        'properties': {},
        'geometry': {
          'type': 'LineString',
          'coordinates': coordinates
        }
      };

      map.addLayer({
        'id': 'route',
        'type': 'line',
        'source': {
          'type': 'geojson',
          'data': geojson
        },
        'layout': {
          'line-join': 'round',
          'line-cap': 'round'
        },
        'paint': {
          'line-color': '#3887be',
          'line-width': 5,
          'line-opacity': 0.75
        }
      });
    })
}

const mapPosition = (start, end) => {
  const bounds = [
    [start.lng, start.lat],
    [end.lng, end.lat]
  ];
  
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  const marker = new mapboxgl.Marker(element)
    .setLngLat([start.lng,start.lat])
      .addTo(map);
      const marker3 = new mapboxgl.Marker(element2)
      .setLngLat([end.lng,end.lat])
        .addTo(map);
}

const addMarkers = (start, end) => {
  //
}

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const start = JSON.parse(mapElement.dataset.start)
    const end = JSON.parse(mapElement.dataset.end)
    addMarkers(start, end)
    addItinerary(start, end)
    mapPosition(start, end)
  }
};

export { initMapbox };
