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
end
