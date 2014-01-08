require 'file'

class RestaurantsController < ApplicationController
  def index
    @city = params[:city]
    @category = params[:category]
    @restaurants = Restaurant.where("city_name = ? AND category = ?", @city, @category)
    render :json => {
      :restaurants => @restaurants.map {|r| r.to_json}
    }
  end

  def show
  	@r = Restaurant.find_by_id params[:id]
  	render :json => {
  		:restaurant => @r.to_json
  	}
  end
end
