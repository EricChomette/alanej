class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    @station = Station.find(params[:station_id])
    @review.station = @station
    if @review.save
      redirect_to station_path(@station, anchor: "#container-reviews")
    else
      render 'stations/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :visitor_pseudo)
  end
end
