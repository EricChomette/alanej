class StationsController < ApplicationController
  require "uri"
  require "net/http"
  require "json"
  require 'open-uri'
  require 'date'

  # def create_from_sortable
  #   puts "hello"
  #   @tab = params["tab"]
  # end

  def index
    if (params[:query][:start_date] != "") && (params[:query][:end_date] != "") && (params[:city] != "")
      @stations_data = BestStations.new(params[:query][:start_date], params[:query][:end_date], params[:city], %w[snow budget trip weather]).call
    else
      render "home"
    end
  end

  def show
    @station = Station.find(params[:id])
    @review = Review.new
    @reviews = @station.reviews
    @average_rating = @reviews.average(:rating).round(2) if @reviews.count.positive?
    @dates = (params[:start_date].to_date..params[:end_date].to_date)
  end
end
