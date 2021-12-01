  # def budget(station)
  #   lnglat_start = find_start_coordonates

  #   URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station_data.long},#{station.lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
  #     trajet = JSON.parse(stream.read)["routes"]
  #     return (trajet[0]["distance"] / 1000 * 0.246559).to_i
  #   end
  # end







        <img class="plan" src="<%= @station.plan %>" alt="plan">





                      <div class="card-station-slops">
                    <div class="Flag-total">
                      <p><%= ((station.green_open_slopes + station.blue_open_slopes + station.red_open_slopes + station.black_open_slopes).to_f / (station.green_slopes + station.blue_slopes + station.red_slopes + station.black_slopes) * 100 ).round(0) %> % de pistes ouvertes</p>
                    </div>
                    <div class="Flag-array">
                      <p class="d-flex" ><%= station.green_open_slopes %> / <%= station.green_slopes %>  <i class="fas fa-flag green"></i></p>
                      <p class="d-flex" ><%= station.blue_open_slopes %> / <%= station.blue_slopes %>  <i class="fas fa-flag blue"></i></p>
                      <p class="d-flex" ><%= station.red_open_slopes %> / <%= station.red_slopes %>  <i class="fas fa-flag red"></i></p>
                      <p class="d-flex" ><%= station.black_open_slopes %> / <%= station.black_slopes %>  <i class="fas fa-flag black"></i></p>
                    </div>

                  </div>
