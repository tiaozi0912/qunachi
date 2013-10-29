require 'rest_client'
require 'json' 

class AuthController < ApplicationController
  def create_user from, token, uid, success_redirect_url, fail_redirect_url, response
  	@dump = token.sub(/[^\w]+/, '')[0..9]
  	@name = response["user"].nil? ? nil : response["user"]["name"]

  	@user = User.new({
      :name => @name || @dump,
      :username => @dump,
      :email => "#{@dump}@gmail.com",
      :password => @dump,
      :password_confirmation => @dump,
      :"#{from.downcase}_access_token" => token,
      :"#{from.downcase}_uid" => uid
    })

    if @user.save
      flash[:'alert-success'] = 'Sign in successfully.'
      redirect_to success_redirect_url
    else 
      flash[:'alert-error'] = @user.errors.full_messages
      redirect_to fail_redirect_url
    end
  end

  def signin_or_create from, token, uid, success_redirect_url, fail_redirect_url, response
  	@user = User.where("#{from.downcase}_access_token = ?", token).first
    if @user.nil?
    	create_user from, token, uid, success_redirect_url, fail_redirect_url, response
    else
      @session = UserSession.create(@user, true)
      flash[:'alert-success'] = 'Sign in successfully.'
    	redirect_to success_redirect_url
    end
  end

  def get_access_token_and_signin from, code
  	WEIBO[:endpoint] = "https://api.weibo.com/oauth2/access_token"
  	RENREN[:endpoint] = "https://graph.renren.com/oauth/token"

  	@endpoint = from.constantize[:endpoint]
    @params = {
    	:client_id => from.constantize[:app_key],
      :client_secret => from.constantize[:app_secret],
      :grant_type => 'authorization_code',
      :redirect_uri => from.constantize[:redirect_uri],
      :code => code
    }

    RestClient.post(@endpoint, @params) { |response, request, result|
      response = JSON.parse(response)
      @access_token = response["access_token"]
      @uid = response["uid"] || response["user"]["id"]
      if @access_token.nil?
        #handle error
        render :json => response
      else
      	if UserSession.find.nil?
          signin_or_create from, @access_token, @uid, user_profile_path, root_path, response
        else
        	# session alreay there
        	# only save the retrieved access token and other necessary information
          current_user["#{from.downcase}_access_token"] = @access_token
          if from == 'WEIBO'
            current_user[:weibo_uid] = response['uid'].to_i
          elsif from == 'RENREN'
          	current_user[:renren_uid] = response["user"]["id"]
          end
          current_user.save
          redirect_to user_profile_path
        end
      end
    }
  end

  private

  def get_user_info_on_weibo token, uid
    @endpoint = "https://api.weibo.com/2/users/show.json"
    @params = {
      :access_token => token,
      :uid => uid,
      :source => WEIBO[:app_key]
    }
    # get user name
    response = RestClient.get(@endpoint, :params => @params)
    return JSON.parse(response);
  end
end