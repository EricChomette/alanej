require 'open-uri'
require 'date'

SUNICO = [
  "Soleil"
]
SUNCLOUD = [
  "Peu nuageux", "Ciel voilé"
]
CLOUDS = [
  "Nuageux", "Couvert"
]
BIGCLOUDS = [
  "Très nuageux"
]
BIGRAIN = [
  "Averses de pluie et neige mêlées fortes et fréquentes", "Pluie forte intermittente", "Averses de pluie fortes et fréquentes", "Averses locales et fortes", "Averses de pluie fortes", "Pluie forte verglaçante", "Averses de pluie et neige mêlées fortes"

]
LITTLERAIN = [
  "Pluie faible", "Averses de pluie locales et faibles", "Pluie faible intermittente", "Pluie forte", "Pluie faible verglaçante", "Averses de pluie locales", "Averses de pluie faibles", "Averses de pluie faibles et fréquentes"
]
RAIN = [
  "Pluie modérée", "Pluie modérée verglaçante", "Pluie et neige mêlées modérées", "Averses de pluie", "Averses de pluie fréquentes", "Averses de pluie et neige mêlées localisées", "Averses de pluie et neige mêlées localisées et fortes", "Averses de pluie et neige mêlées", "Averses de pluie et neige mêlées fréquentes",  "Pluie et neige mêlées", "Pluie et neige mêlées", "Pluie et neige mêlées"
]
RAINANDSNOW = [ "Pluie et neige mêlées faibles", "Averses de pluie et neige mêlées localisées et faibles", "Averses de pluie et neige mêlées faibles","Averses de pluie et neige mêlées faibles et nombreuses", "Pluie et neige mêlées fortes",
]

FOG = [
  "Bruine", "Brouillard", "Brouillard givrant"
]
GRELE = [
  "Averses de grêle"
]
SNOW = [
  "Neige forte", "Neige modérée", "Averses de neige localisées et fortes", "Averses de neige", "Averses de neige fortes", "Averses de neige fréquentes", "Averses de neige fortes et fréquentes", "Neige forte intermittente"
]
LITTLESNOW = [
  "Neige faible", "Neige modérée", "Averses de neige localisées et faibles", "Averses de neige localisées", "Averses de neige faibles", "Averses de neige faibles et fréquentes", "Neige faible intermittente", "Neige modérée intermittente"
]

STORM = [
  "Orages faibles et locaux", "Orages locaux", "Orages fort et locaux", "Orages faibles", "Orages", "Orages forts", "Orages faibles et fréquents", "Orages fréquents", "Orages forts et fréquents", "Orages faibles et locaux de neige ou grésil", "Orages locaux de neige ou grésil", "Orages locaux de neige ou grésil", "Orages faibles de neige ou grésil", "Orages de neige ou grésil", "Orages faibles et fréquents de neige ou grésil","Orages fréquents de neige ou grésil"
]
STORMRAIN = [
  "Orages faibles et locaux de pluie et neige mêlées ou grésil", "Orages locaux de pluie et neige mêlées ou grésil", "Orages fort et locaux de pluie et neige mêlées ou grésil", "Orages faibles de pluie et neige mêlées ou grésil", "Orages de pluie et neige mêlées ou grésil", "Orages forts de pluie et neige mêlées ou grésil", "Orages faibles et fréquents de pluie et neige mêlées ou grésil", "Orages fréquents de pluie et neige mêlées ou grésil", "Orages forts et fréquents de pluie et neige mêlées ou grésil", "Pluies orageuses", "Pluie et neige mêlées à caractère orageux", "Neige à caractère orageux", "Pluie modérée intermittente"
]

FIVE_W = [
  "Soleil", "Peu nuageux"
]
FOUR_W = [
  "Ciel voilé", "Nuageux", "Neige faible"
]
THREE_W = [
  "Très nuageux", "Couvert", "Bruine", "Neige modérée", "Averses de neige localisées et faibles", "Averses de neige localisées", "Averses de neige faibles", "Averses de neige faibles et fréquentes", "Neige faible intermittente"
]

TWO_W = [
  "Brouillard", "Pluie faible", "Neige forte", "Pluie et neige mêlées faibles", "Averses de pluie locales et faibles", "Averses de neige localisées et fortes", "Averses de neige", "Averses de neige fortes", "Averses de neige fréquentes", "Averses de neige fortes et fréquentes", "Averses de pluie et neige mêlées localisées et faibles", "Pluie faible intermittente", "Neige modérée intermittente"
]

ONE_W = [
  "Brouillard givrant", "Pluie modérée", "Pluie forte", "Pluie faible verglaçante", "Pluie modérée verglaçante", "Pluie forte verglaçante", "Pluie et neige mêlées modérées", "Pluie et neige mêlées fortes", "Averses de pluie locales", "Averses locales et fortes", "Averses de pluie faibles", "Averses de pluie", "Averses de pluie fortes", "Averses de pluie faibles et fréquentes",
  "Averses de pluie fréquentes", "Averses de pluie fortes et fréquentes", "Averses de pluie et neige mêlées localisées", "Averses de pluie et neige mêlées localisées et fortes", "Averses de pluie et neige mêlées faibles", "Averses de pluie et neige mêlées", "Averses de pluie et neige mêlées fortes", "Averses de pluie et neige mêlées faibles et nombreuses", "Averses de pluie et neige mêlées fréquentes", "Averses de pluie et neige mêlées fortes et fréquentes", "Orages faibles et locaux", "Orages locaux", "Orages fort et locaux",
  "Orages faibles", "Orages", "Orages forts", "Orages faibles et fréquents", "Orages fréquents", "Orages forts et fréquents", "Orages faibles et locaux de neige ou grésil", "Orages locaux de neige ou grésil", "Orages locaux de neige ou grésil", "Orages faibles de neige ou grésil", "Orages de neige ou grésil", "Orages faibles et fréquents de neige ou grésil",
  "Orages fréquents de neige ou grésil", "Orages faibles et locaux de pluie et neige mêlées ou grésil", "Orages locaux de pluie et neige mêlées ou grésil", "Orages fort et locaux de pluie et neige mêlées ou grésil", "Orages faibles de pluie et neige mêlées ou grésil", "Orages de pluie et neige mêlées ou grésil", "Orages forts de pluie et neige mêlées ou grésil", "Orages faibles et fréquents de pluie et neige mêlées ou grésil", "Orages fréquents de pluie et neige mêlées ou grésil",
  "Orages forts et fréquents de pluie et neige mêlées ou grésil", "Pluies orageuses", "Pluie et neige mêlées à caractère orageux", "Neige à caractère orageux", "Pluie modérée intermittente", "Pluie forte intermittente", "Neige forte intermittente", "Pluie et neige mêlées", "Pluie et neige mêlées", "Pluie et neige mêlées", "Averses de grêle"
]

NB_STATIONS = 5

FIVE_S = (131..500)
FOUR_S = (71..130)
THREE_S = (41..70)
TWO_S = (21..40)
ONE_S = (0..20)

FIVE_T = (0..60)
FOUR_T = (61..90)
THREE_T = (91..120)
TWO_T = (121..240)

class BestStations
  def initialize(start_date, end_date, address, criterias)
    @start_date = start_date.to_date.yday - Time.now.yday
    @end_date = end_date.to_date.yday - Time.now.yday
    @address = address
    @criterias = criterias
  end

  def call
    find_stations
    assign_durations
    assign_wheater
    assign_snow
    calcul_ratings
    sort
    @stations_data
  end

  private

  def undegeuify(string)
    string.split(',').map { |s| s.gsub(/[^0-9]/, '')}
  end

  def find_stations
    @stations_data = Station.all.map {|s| {station: s} }
  end

  def assign_durations
    @stations_data.each do |station_data|
      station_data[:duration] = tmp_trajet(station_data)
    end
  end

  def find_start_coordonates
    coordonates = []
    url = "https://api.myptv.com/geocoding/v1/locations/by-text?searchText=#{@address}&apiKey=NDNlYzA1M2M2YTBiNGU1YWIwMDI3NjJmZTZjZjUzNTI6MDU0NzgyOTYtMTgwZi00NTliLTg5NzYtMjA2YmEyODA3YjYw"
    url = url.chars.map { |char| char.ascii_only? ? char : CGI.escape(char) }.join
    URI.open(url) do |stream|
      row = JSON.parse(stream.read)
      coordonates.push(row["locations"][0]["referencePosition"]["longitude"])
      coordonates.push(row["locations"][0]["referencePosition"]["latitude"])
      return coordonates
    end
  end

  def tmp_trajet(station_data)
    lnglat_start = find_start_coordonates

    URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station_data[:station].long},#{station_data[:station].lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
      trajet = JSON.parse(stream.read)["routes"]
      trajet_duration = (trajet[0]["duration"] / 60).to_i
      # sleep(2.seconds)
      return trajet_duration
    end
  end


  def assign_wheater
    dates = (@start_date..@end_date)
    @stations_data.each do |station_data|
      array = []
      station_data[:station].conditions.each do |condition|
        array << condition.weather
      end
      station_data[:weather] = array[(dates)]
    end
  end

  def assign_snow
    @stations_data.each do |station_data|
      station_data[:station].conditions.each do |condition|
        station_data[:snow] = undegeuify(condition.snow)
      end
    end
  end

  def calcul_ratings
    calc_rating_duration
    @stations_data.each do |station_data|
      calc_rating_weather(station_data)
      calc_rating_snow(station_data)
      calc_rating_budget(station_data)
      calcul_global_rating(station_data)
    end
  end

  def calcul_global_rating(station_data)
    duration_rating = station_data[:duration_rating]
    weather_rating = station_data[:weather_rating]
    snow_rating = station_data[:snow_rating]
    budget_rating = station_data[:budget_rating]
    case @criterias[0]
    when "snow"
      snow_rating *= 10
    when "weather"
      weather_rating *= 10
    when "budget"
      budget_rating *= 10
    when "trip"
      duration_rating *= 10
    end

    case @criterias[1]
    when "snow"
      snow_rating *= 7
    when "weather"
      weather_rating *= 7
    when "budget"
      budget_rating *= 7
    when "trip"
      duration_rating *= 7
    end

    case @criterias[2]
    when "snow"
      snow_rating *= 3
    when "weather"
      weather_rating *= 3
    when "budget"
      budget_rating *= 3
    when "trip"
      duration_rating *= 3
    end

    case @criterias[3]
    when "snow"
      snow_rating *= 1
    when "weather"
      weather_rating *= 1
    when "budget"
      budget_rating *= 1
    when "trip"
      duration_rating *= 1
    end

    station_data[:global_rating] = ((duration_rating + weather_rating + snow_rating + budget_rating) / 21).round(2)
  end

  def sort
    @stations_data.sort! {|a, b| b[:global_rating] <=> a[:global_rating]}
  end

  def calc_rating_duration
    @stations_data.sort! {|a, b| a[:duration] <=> b[:duration]}
    @stations_data.each_with_index do |station_data, index|
      station_data[:duration_rating] = ( (@stations_data.count - index) * (5.to_f / @stations_data.count) )
    end
  end

  def calc_rating_weather(station_data)
    array = []
    station_data[:weather].each do |weather|

      if FIVE_W.include?(weather)
        array << 5
      elsif FOUR_W.include?(weather)
        array << 4
      elsif THREE_W.include?(weather)
        array << 3
      elsif TWO_W.include?(weather)
        array << 2
      elsif ONE_W.include?(weather)
        array << 1
      end
    end
    station_data[:weather_rating] = (array.sum.to_f / array.count).round(2)
  end

  def calc_rating_snow(station_data)
    array = []
    station_data[:snow].each do |snow|
      snow = snow.to_i
      if FIVE_S.include?(snow)
        array << 5
      elsif FOUR_S.include?(snow)
        array << 4
      elsif THREE_S.include?(snow)
        array << 3
      elsif TWO_S.include?(snow)
        array << 2
      elsif ONE_S.include?(snow)
        array << 1
      end
    end
    station_data[:snow_rating] = (array.sum.to_f / array.count).round(2)
  end

  def calc_rating_budget(station_data)
    case station_data[:station].budget
    when "1"
      station_data[:budget_rating] = 5.0
    when "2"
      station_data[:budget_rating] = 4.0
    when "3"
      station_data[:budget_rating] = 3.0
    when "4"
      station_data[:budget_rating] = 2.0
    when "5"
      station_data[:budget_rating] = 1.0
    end
  end

end
