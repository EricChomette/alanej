  # def budget(station)
  #   lnglat_start = find_start_coordonates

  #   URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station_data.long},#{station.lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
  #     trajet = JSON.parse(stream.read)["routes"]
  #     return (trajet[0]["distance"] / 1000 * 0.246559).to_i
  #   end
  # end







  # def find_forecast(date, station)
#   URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=f9e68c52be15a27603ac5ee02abf853316482e6d2ac1c111f58ed481816938b8&insee=#{station.insee}") do |stream|
#     return JSON.parse(stream.read)['forecast']
#   end
# end

# def weather(date, station)
#   forecast = find_forecast(date, station)
#   return WEATHER[forecast['weather']]
# end

# def frost(date, station)
#   forecast = find_forecast(date, station)
#   return forecast['probafrost']
# end

# def fog(date, station)
#   forecast = find_forecast(date, station)
#   return forecast['probafog']
# end

# def bot_snow(html_doc)
#   bot_array = []
#   html_doc.search('.snow-medium').each do |element|
#     bot_array << element.text.strip
#   end
#   return bot_array
# end

# def submit_snow(html_doc)
#   submit_array = []
#   html_doc.search('.snow-big').each do |element|
#     submit_array << element.text.strip
#   end
#   return submit_array
# end

# def snow(station)
#   bot_submit_array = []
#   html_file = URI.open("https://wepowder.com/fr/#{station.snowurl}").read
#   html_doc = Nokogiri::HTML(html_file)

#   bot_array = bot_snow(html_doc)
#   submit_array = submit_snow(html_doc)

#   bot_submit_array << submit_array.first
#   bot_submit_array << bot_array[1]
# end

# def new_condition(station) # dans le job
#   (0..7).each do |date|
#     real_date = Time.zone.now + date.day
#     p real_date
#     Condition.create!(
#       station: station,
#       date_on: real_date,
#       weather: weather(date, station),
#       frost_prob: frost(date, station),
#       fog_prob: fog(date, station),
#       snow: snow(station)
#     )
#   end
# end
