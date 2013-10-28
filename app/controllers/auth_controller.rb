require 'rest_client'
require 'json' 

class AuthController < ApplicationController
	def create_with_weibo uid, token, success_redirect_url, fail_redirect_url
    @endpoint = "https://api.weibo.com/2/users/show.json"
    @params = {
      :access_token => token,
      :uid => uid,
      :source => WEIBO[:app_key]
    }
    # get user name
    RestClient.get(@endpoint, :params => @params) { |response, request, result|
      response = JSON.parse(response)
      @name = response["name"]
      @user = User.new({
        :name => @name,
        :username => @name.sub(/[^\w]+/,''),
        :email => "#{@name.sub(/[^\w]+/,'')}@gmail.com",
        :password => @name.sub(/[^\w]+/,''),
        :password_confirmation => @name.sub(/[^\w]+/,''),
        :weibo_access_token => token,
        :weibo_uid => uid
      })
      if @user.save
        flash[:'alert-success'] = 'Sign in successfully.'
        redirect_to success_redirect_url
      else 
        flash[:'alert-error'] = @user.errors.full_messages
        redirect_to fail_redirect_url
      end
    }
  end

  def signin_or_create_with_weibo token, uid, success_redirect_url, fail_redirect_url
    @user = User.find_by_weibo_access_token(token)
    if @user.nil?
      create_with_weibo uid, token, success_redirect_url, fail_redirect_url
    else
      @session = UserSession.create(@user, true)
      flash[:'alert-success'] = 'Sign in successfully.'
      redirect_to success_redirect_url
    end
  end
end