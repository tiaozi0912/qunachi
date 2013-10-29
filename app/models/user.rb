require 'rest_client'
require 'json' 

class User < ActiveRecord::Base
  attr_accessible :name, :username, :email, :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count, :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip, :password, :password_confirmation, :weibo_access_token, :renren_access_token, :facebook_access_token, :instagram_access_token, :weibo_uid, :renren_uid, :facebook_uid, :instagram_uid

  acts_as_authentic do |c|
  	# pass config option if any
  	c.login_field = 'username'
  end

  def self.auth_link
  	return {
  		:weibo => "https://api.weibo.com/oauth2/authorize?client_id=#{WEIBO[:app_key]}&response_type=code&redirect_uri=#{WEIBO[:redirect_uri]}",
      :renren => "https://graph.renren.com/oauth/authorize?client_id=#{RENREN[:app_key]}&response_type=code&redirect_uri=#{RENREN[:redirect_uri]}&scope=read_user_feed"
  	}
  end

end
