class StationsController < ApplicationController
  require "uri"
  require "net/http"
  require "json"
  require 'open-uri'
  require 'date'

  MONTHS = ["rien", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"]

  def index
    # @stations = Station.all
    @stations_data = BestStations.new(params[:query][:start_date], params[:query][:end_date], params[:city], %w[trip snow weather budget]).call
  end

  def show
    @station = Station.find(params[:id])
    @review = Review.new
    @month = MONTHS[Time.now.month]
    @reviews = @station.reviews
    @average_rating = @reviews.average(:rating).round(2) if @reviews.count.positive?

    @dates = ((params[:start_date].to_date.yday - Time.now.yday)..(params[:end_date].to_date.yday - Time.now.yday))
  end
end
