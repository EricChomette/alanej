  # def budget(station)
  #   lnglat_start = find_start_coordonates

  #   URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station_data.long},#{station.lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
  #     trajet = JSON.parse(stream.read)["routes"]
  #     return (trajet[0]["distance"] / 1000 * 0.246559).to_i
  #   end
  # end
