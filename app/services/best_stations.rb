# [
#   {
#     station: <Station:0x00007fa77e031e20>,
#     duration: 3456 # minutes
#     snow: 12 cm
#   }

#   {
#     station: <Station:0x00007fa79e029e20>,
#     duration: 2863 # minutes
#     weather:
#     snow: 10 cm
#   }


# ]
require 'open-uri'



class BestStations
  def initialize(start_date, end_date, address, criterias)
    @start_date = start_date.to_date.day - Time.now.day
    @end_date = end_date.to_date.day - Time.now.day
    @address = address
    @criterias = criterias
  end

  def call
    find_stations
    assign_durations
    assign_wheater
    assign_snow
    calcul_ratings
    # sort
    # @station_datas
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

  def time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    rest = "0#{rest}" if rest < 10
    return "#{hours}h#{rest}"
  end

  def tmp_trajet(station_data)
    lnglat_start = find_start_coordonates

    URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station_data[:station].long},#{station_data[:station].lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
      trajet = JSON.parse(stream.read)["routes"]
      trajet_duration = (trajet[0]["duration"] / 60).to_i
      # sleep(2.seconds)
      return time_conversion(trajet_duration)
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
    @stations_data.each do |station_data|
      calc_rating_duration(@station_data)
      calc_rating_weather(station_data)
      calc_rating_snow(station_data)
      calc_rating_budget(station_data)
    end
  end

  # def sort

  # end

  def calc_rating_duration(station_data)
    station_data[:duration]
    station_data[:durating_rating] = station_data[:duration]

  end
  # traj_temps_sorted = traj_temps.sort_by { |k, v| v }
  # traj_notes = []
  # traj_temps_sorted.each_with_index do |station, index|
  #   traj_notes << [station[0], ((20 - index).to_f / 4).round(2)]
  # end
  # raise
  # return traj_notes

  def calc_rating_weather(station_data)

  end

  def calc_rating_snow(station_data)

  end

  def calc_rating_budget(station_data)

  end

end
