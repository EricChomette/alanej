class StationsController < ApplicationController
  require "uri"
  require "net/http"
  require "json"
  require 'open-uri'

  MONTHS = ["rien", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"]

  def index
    @stations = Station.all
    @dates = ((params[:query][:start_date].split("-").last.to_i)..(params[:query][:end_date].split("-").last.to_i))
    # criterias = %w[weather snow budget trip]
    # BestStations(params[:query][:start_date], params[:query][:end_date], params[:city], criterias)
    # @traj_temps = {}
    # @stations.each do |station|
    #   @traj_temps[station.name] = tmp_trajet(station) unless params[:city] == ""
    # end
    # traj_rating(@traj_temps)
  end



  def show
    @station = Station.find(params[:id])
    @review = Review.new
    @month = MONTHS[Time.now.month]
    @reviews = @station.reviews
    @average_rating = @reviews.average(:rating).round(2) if @reviews.count.positive?
    @dates = ((params[:start_date].split("-").last.to_i)..(params[:end_date].split("-").last.to_i))
  end


  # def find_start_coordonates
  #   coordonates = []
  #   url = "https://api.myptv.com/geocoding/v1/locations/by-text?searchText=#{params[:city]}&apiKey=NDNlYzA1M2M2YTBiNGU1YWIwMDI3NjJmZTZjZjUzNTI6MDU0NzgyOTYtMTgwZi00NTliLTg5NzYtMjA2YmEyODA3YjYw"
  #   url = url.chars.map { |char| char.ascii_only? ? char : CGI.escape(char) }.join
  #   URI.open(url) do |stream|
  #     row = JSON.parse(stream.read)
  #     coordonates.push(row["locations"][0]["referencePosition"]["longitude"])
  #     coordonates.push(row["locations"][0]["referencePosition"]["latitude"])
  #     return coordonates
  #   end
  # end

  # def time_conversion(minutes)
  #   hours = minutes / 60
  #   rest = minutes % 60
  #   rest = "0#{rest}" if rest < 10
  #   return "#{hours}h#{rest}"
  # end

  # def tmp_trajet(station)
  #   lnglat_start = find_start_coordonates

  #   URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station.long},#{station.lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
  #     trajet = JSON.parse(stream.read)["routes"]
  #     trajet_duration = (trajet[0]["duration"] / 60).to_i
  #     sleep(2.seconds)
  #     return time_conversion(trajet_duration)
  #   end
  # end

  # def budget(station)
  #   lnglat_start = find_start_coordonates

  #   URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/#{lnglat_start[0]},#{lnglat_start[1]};#{station.long},#{station.lat}?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
  #     trajet = JSON.parse(stream.read)["routes"]
  #     return (trajet[0]["distance"] / 1000 * 0.246559).to_i
  #   end
  # end
end
