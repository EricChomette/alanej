class StationsController < ApplicationController
  require "uri"
  require "net/http"
  require "json"
  require 'open-uri'

  WEATHER = {
    0 => "Soleil",
    1 => "Peu nuageux",
    2 => "Ciel voilé",
    3 => "Nuageux",
    4 => "Très nuageux",
    5 => "Couvert",
    6 => "Brouillard",
    7 => "Brouillard givrant",
    10 => "Pluie faible",
    11 => "Pluie modérée",
    12 => "Pluie forte",
    13 => "Pluie faible verglaçante",
    14 => "Pluie modérée verglaçante",
    15 => "Pluie forte verglaçante",
    16 => "Bruine",
    20 => "Neige faible",
    21 => "Neige modérée",
    22 => "Neige forte",
    30 => "Pluie et neige mêlées faibles",
    31 => "Pluie et neige mêlées modérées",
    32 => "Pluie et neige mêlées fortes",
    40 => "Averses de pluie locales et faibles",
    41 => "Averses de pluie locales",
    42 => "Averses locales et fortes",
    43 => "Averses de pluie faibles",
    44 => "Averses de pluie",
    45 => "Averses de pluie fortes",
    46 => "Averses de pluie faibles et fréquentes",
    47 => "Averses de pluie fréquentes",
    48 => "Averses de pluie fortes et fréquentes",
    60 => "Averses de neige localisées et faibles",
    61 => "Averses de neige localisées",
    62 => "Averses de neige localisées et fortes",
    63 => "Averses de neige faibles",
    64 => "Averses de neige",
    65 => "Averses de neige fortes",
    66 => "Averses de neige faibles et fréquentes",
    67 => "Averses de neige fréquentes",
    68 => "Averses de neige fortes et fréquentes",
    70 => "Averses de pluie et neige mêlées localisées et faibles",
    71 => "Averses de pluie et neige mêlées localisées",
    72 => "Averses de pluie et neige mêlées localisées et fortes",
    73 => "Averses de pluie et neige mêlées faibles",
    74 => "Averses de pluie et neige mêlées",
    75 => "Averses de pluie et neige mêlées fortes",
    76 => "Averses de pluie et neige mêlées faibles et nombreuses",
    77 => "Averses de pluie et neige mêlées fréquentes",
    78 => "Averses de pluie et neige mêlées fortes et fréquentes",
    100 => "Orages faibles et locaux",
    101 => "Orages locaux",
    102 => "Orages fort et locaux",
    103 => "Orages faibles",
    104 => "Orages",
    105 => "Orages forts",
    106 => "Orages faibles et fréquents",
    107 => "Orages fréquents",
    108 => "Orages forts et fréquents",
    120 => "Orages faibles et locaux de neige ou grésil",
    121 => "Orages locaux de neige ou grésil",
    122 => "Orages locaux de neige ou grésil",
    123 => "Orages faibles de neige ou grésil",
    124 => "Orages de neige ou grésil",
    125 => "Orages de neige ou grésil",
    126 => "Orages faibles et fréquents de neige ou grésil",
    127 => "Orages fréquents de neige ou grésil",
    128 => "Orages fréquents de neige ou grésil",
    130 => "Orages faibles et locaux de pluie et neige mêlées ou grésil",
    131 => "Orages locaux de pluie et neige mêlées ou grésil",
    132 => "Orages fort et locaux de pluie et neige mêlées ou grésil",
    133 => "Orages faibles de pluie et neige mêlées ou grésil",
    134 => "Orages de pluie et neige mêlées ou grésil",
    135 => "Orages forts de pluie et neige mêlées ou grésil",
    136 => "Orages faibles et fréquents de pluie et neige mêlées ou grésil",
    137 => "Orages fréquents de pluie et neige mêlées ou grésil",
    138 => "Orages forts et fréquents de pluie et neige mêlées ou grésil",
    140 => "Pluies orageuses",
    141 => "Pluie et neige mêlées à caractère orageux",
    142 => "Neige à caractère orageux",
    210 => "Pluie faible intermittente",
    211 => "Pluie modérée intermittente",
    212 => "Pluie forte intermittente",
    220 => "Neige faible intermittente",
    221 => "Neige modérée intermittente",
    222 => "Neige forte intermittente",
    230 => "Pluie et neige mêlées",
    231 => "Pluie et neige mêlées",
    232 => "Pluie et neige mêlées",
    235 => "Averses de grêle",
  }

  def index
    @meteos = {}
    @traj_temps = {}
    @budget = {}

    @stations = Station.all

    @stations.each do |station|
      if (params[:start_date] != "") && (params[:end_date] != "")
        @meteos[station.id] = meteo(station)
      end
      if params[:city] != ""
        @traj_temps[station.id] = tmp_trajet(station)
        @budget[station.id] = budget(station)
      end
    end
  end

  def meteo(station)
    date_debut = params[:start_date].split("-").last.to_i - Time.now.day
    date_fin = params[:end_date].split("-").last.to_i - Time.now.day
    dates = (date_debut..date_fin)
    dates.each do |date|
      URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=25b726a85bb8874026726594e8131564066e1794ef1e71a60a86f019e5e1968d&insee=#{station.insee}") do |stream|
        forecast = JSON.parse(stream.read)['forecast']
        return WEATHER[forecast['weather']]
      end
    end
  end

  def show
    @station = Station.find(params[:id])
    @review = Review.new
    @reviews = @station.reviews

    if @reviews.count.positive?
      @average_rating = @reviews.average(:rating).round(2)
    end
    if (params[:start_date] != "") && (params[:end_date] != "")
      date_debut = params[:start_date].split("-").last.to_i - Time.now.day
      date_fin = params[:end_date].split("-").last.to_i - Time.now.day
      @weathers = {}
      @proba_frosts = {}
      @proba_rains = {}
      @proba_fogs = {}
      @dates = (date_debut..date_fin)
      @dates.each do |date|
        @weathers[date] = meteo_show(date, @station)
        @proba_frosts[date] = frost_show(date, @station)
        @proba_rains[date] = rain_show(date, @station)
        @proba_fogs[date] = fog_show(date, @station)
      end

    end
  end

  def meteo_show(date, station)
    URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=25b726a85bb8874026726594e8131564066e1794ef1e71a60a86f019e5e1968d&insee=#{station.insee}") do |stream|
      forecast = JSON.parse(stream.read)['forecast']
      return (WEATHER[forecast['weather']])
    end
  end

  def frost_show(date, station)
    URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=25b726a85bb8874026726594e8131564066e1794ef1e71a60a86f019e5e1968d&insee=#{station.insee}") do |stream|
      forecast = JSON.parse(stream.read)['forecast']
      return forecast['probafrost']
    end
  end

  def rain_show(date, station)
    URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=25b726a85bb8874026726594e8131564066e1794ef1e71a60a86f019e5e1968d&insee=#{station.insee}") do |stream|
      forecast = JSON.parse(stream.read)['forecast']
      return forecast['probarain']
    end
  end

  def fog_show(date, station)
    URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=25b726a85bb8874026726594e8131564066e1794ef1e71a60a86f019e5e1968d&insee=#{station.insee}") do |stream|
      forecast = JSON.parse(stream.read)['forecast']
      return forecast['probafog']
    end
  end

  def find_start_coordonates
    coordonates = []
    url = "https://api.myptv.com/geocoding/v1/locations/by-text?searchText=#{params[:city]}&apiKey=NDNlYzA1M2M2YTBiNGU1YWIwMDI3NjJmZTZjZjUzNTI6MDU0NzgyOTYtMTgwZi00NTliLTg5NzYtMjA2YmEyODA3YjYw"
    url = url.chars.map { |char| char.ascii_only? ? char : CGI.escape(char) }.join
    URI.open(url) do |stream|
      row = JSON.parse(stream.read)
      coordonates.push(row["locations"][0]["referencePosition"]["longitude"])
      coordonates.push(row["locations"][0]["referencePosition"]["latitude"])
      return coordonates
    end
  end

  def time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    if rest < 10
      rest = "0#{rest}"
    end
    return "#{hours}h#{rest}"
  end

  def tmp_trajet(station)
    lnglat_start = find_start_coordonates

    URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station.long},#{station.lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
      trajet = JSON.parse(stream.read)["routes"]
      trajet_duration = (trajet[0]["duration"] / 60).to_i
      return time_conversion(trajet_duration)
    end

  end

  def budget(station)
    lnglat_start = find_start_coordonates

    URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station.long},#{station.lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
      trajet = JSON.parse(stream.read)["routes"]
      budget_car = (trajet[0]["distance"] / 1000 * 0.246559).to_i
      return budget_car
    end
  end
end
