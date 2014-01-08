require 'file'

class Admin::RestaurantsController < ApplicationController
  before_filter :admin_auth
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
    @body_class = 'restaurants-admin'
  end

  def list
    render :json => Restaurant.order('name ASC').all.map {|r| r.to_json}
  end

  def new
    @body_class = 'restaurants-new-admin'
    @r = Restaurant.new
  end

  def create
    @r = Restaurant.new params[:restaurant]
    if @r.save
      flash['alert-success'] = 'created.'
      redirect_to '/admin/restaurants'
    else 
      flash.now['alert-error'] = @r.errors.full_messages
      render 'new'
    end
  end

  def edit
    @body_class = 'restaurants-edit-admin'
    @r = Restaurant.find_by_id params[:id]
    render 'new'
  end

  def update
    @r = Restaurant.find_by_id params[:id]
    @r.update_attributes params[:restaurant]
    flash['alert-success'] = 'updated.'
    redirect_to '/admin/restaurants'
  end

  def destroy
    r = Restaurant.find_by_id params[:id]
    if !r.nil?
      r.destroy
      render :json => {
        :success => true,
        :message => 'deleted'
      }
    else 
      render :json => {
        :error => true,
        :message => 'not found the restaurant'
      }
    end
  end
end
