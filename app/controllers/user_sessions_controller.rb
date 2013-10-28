require 'rest_client'
require 'json' 

class UserSessionsController < AuthController
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => :destroy
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to user_path(current_user)
    else
    	flash[:notice] = "Error"
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to users_path
  end

  def get_weibo_access_token
    @code = params[:code]
    @endpoint = "https://api.weibo.com/oauth2/access_token"
    @params = {
      :client_id => WEIBO[:app_key],
      :client_secret => WEIBO[:app_secret],
      :grant_type => 'authorization_code',
      :redirect_uri => WEIBO[:redirect_uri],
      :code => @code
    }
    RestClient.post(@endpoint, @params) { |response, request, result|
      response = JSON.parse(response)
      @access_token = response["access_token"]
      if @access_token.nil?
        #handle error
      else
        signin_or_create_with_weibo @access_token, response["uid"].to_i, user_profile_path, root_path
      end
    }
  end
end
