# [
#   {
#     station: <Station:0x00007fa77e031e20>,
#     duration: 3456 # minutes
#     snow: 12 #cm
#   }


# ]



class BestStations
  def initialize(start_date, end_date, address, criterias)
    @start_date = start_date.to_date.day
    @end_date = end_date.to_date.day
    @address = address
    @criterias = criterias
  end

  def call
    find_stations
    # assign_durations
    # assign_wheater
    # assign_snow
    # sort
    # @station_datas
  end

  private

  def find_stations
    ap "je suis dans #{__method__}"
    @stations_data = Station.all.map {|s| {station: s}}
  end

  def assign_durations
    ap "je suis dans #{__method__}"
    @station_datas.each do |station_data|
        station_data[:snow] = rand(20)
    end
  end

  def assign_wheater
    ap "je suis dans #{__method__}"
    dates = (@start_date..@end_date)
    raise
    dates.each do |date|
      weather(date, @station)
    end
  end

  def find_forecast(date, station)
  URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=2795e22b8eab493448975973cfc123f39c329acb1adbc901e2c0b257059bc02f&insee=#{station.insee}") do |stream|
    return JSON.parse(stream.read)['forecast']
  end
end

def weather(date, station)
  forecast = find_forecast(date, station)
  return (WEATHER[forecast['weather']])
end

  def assign_snow
    ap "je suis dans #{__method__}"
  end

  def sort

    @station_datas.each do |station_data|
      calc_rating_snow(station_data)
      calc_rating_weather(station_data)
      calc_rating_trip(station_data)
      calc_rating_budget(station_data)
    end


  end

  def calc_rating_snow(station_data)

  end


  def calc_rating_weather(station_data)

  end
  def calc_rating_trip(station_data)

  end
  def calc_rating_budget(station_data)

  end

  def calc_rating_trip(traj_temps)
    # traj_temps_sorted = traj_temps.sort_by { |k, v| v }
    # traj_notes = []
    # traj_temps_sorted.each_with_index do |station, index|
    #   traj_notes << [station[0], ((20 - index).to_f / 4).round(2)]
    # end
    # raise
    # return traj_notes
  end

end
