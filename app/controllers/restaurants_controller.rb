require 'file'

class RestaurantsController < ApplicationController
  def index
    @city = params[:city]
    @category = params[:category]
    @restaurants = Restaurant.where("city_name = ? AND category_name = ?", @city, @category)
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

  def search
  	# search category_name, city_name and name
  	@keywords = params[:keywords]
  	#@restaurants = Restaurant.all
  	@restaurants = Restaurant.where("category_name iLIKE ? or city_name iLIKE ? or name iLIKE ?", "%#{@keywords}%", "%#{@keywords}%", "%#{@keywords}%")
   	render :json => {
      :restaurants => @restaurants.map {|r| r.to_json}
    }
  end
end
