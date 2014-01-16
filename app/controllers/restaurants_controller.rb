require 'file'

class RestaurantsController < ApplicationController
  def index
    @city = params[:city]
    @category = params[:category]
    @matched_restaurants = Restaurant.where("city_name = ? AND category_name = ?", @city, @category)
    @suggested_restaurants = Restaurant.recommend @city, @category, @matched_restaurants
    render :json => {
      :restaurants => {
        :matched => @matched_restaurants.map {|r| r.to_json},
        :suggested => @suggested_restaurants[0..4].map {|r| r.to_json}
      }
    }
  end

  def show
  	@r = Restaurant.find_by_id params[:id]
  	render :json => {
  		:restaurant => @r.to_json
  	}
  end

  def search
  	# search category_name, city_name and name
  	@keywords = params[:keywords]
  	#@restaurants = Restaurant.all
  	@restaurants = Restaurant.search @keywords
   	render :json => {
      :restaurants => @restaurants.map {|r| r.to_json}
    }
  end
end
