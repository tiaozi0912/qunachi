require 'rest_client'
require 'json'

class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => [:show, :edit, :update]
  def categories_cities
    render :json => {
      :categories => Category.all.map {|c| c.to_json},
      :cities => City.all.map {|c| c.to_json}
    }
  end

  def home
  end

  def profile
    @user = current_user
  end

  def index
  	@users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to user_path(@user)
    else
      render :action => :new
    end
  end
  
  def show
    @user = current_user
  end

  def get_renren_feeds
    @user = current_user
    @url = "https://api.renren.com/v2/feed/list"
    @params = {:access_token => @user.renren_access_token,
               :feedType => "PUBLISH_ONE_PHOTO"}
    RestClient.get(@url, :params => @params) { |response, request, result|
      render :json => JSON.parse(response)
    }
  end

  def edit
    @user = User.find_by_id params[:id]
  end
  
  def update
    @user = User.find_by_id params[:id]
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end
end
