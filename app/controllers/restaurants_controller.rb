require 'file'

class RestaurantsController < ApplicationController

	def load_sheet_to_database
    @path = 'public/data/data.xlsx'
    @sheet = Roo::Excelx.new(@path)
    @restaurants = File.parse_file(@sheet)
    @r_created = []
    @restaurants.each do |r|
    	@r_exist = Restaurant.find_by_name(r["name"])
    	if @r_exit.nil? || @r.city != r["city"]
    		#@r = {}
    		#r.each {|k, v| @r[k.to_sym] = v}
    		@r_new = Restaurant.create(r)
    		@r_created << @r_new
    	else
    		@r_exist.update_attribtues(r)
    	end
    	Category.create(:name => r["category"]) if Category.find_by_name(r["category"]).nil?
    	City.create(:name => r["city"], :state => r["state"], :zip => r["zip"]) if City.find_by_name(r["city"]).nil?
    end

    render :json => @r_created
  end

  def index
    @city = params[:city]
    @category = params[:category]
    @restaurants = Restaurant.where("city = ? AND category = ?", @city, @category)
    render :json => {
      :restaurants => @restaurants.map {|r| r.to_json}
    }
  end
end
