require 'file'

class RestaurantsController < ApplicationController
  def index
    @city = params[:city]
    @category = params[:category]
    @restaurants = Restaurant.where("city = ? AND category = ?", @city, @category)
    render :json => {
      :restaurants => @restaurants.map {|r| r.to_json}
    }
  end
end
