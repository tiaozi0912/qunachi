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
    flash[:'alert-success'] = "Logout successful!"
    redirect_to root_path
  end

  def get_weibo_access_token
    @code = params["code"]
    if @code.nil?
      #handle error
      flash[:'alert-error'] = params["error"]
      redirect_to root_path
    else
      get_access_token_and_signin "WEIBO", @code
    end
  end

  def get_renren_access_token
    @code = params["code"]
    if @code.nil?
      #handle error
      flash[:'alert-error'] = params["error"]
      redirect_to root_path
    else
      get_access_token_and_signin "RENREN", @code
    end
  end
  
end
