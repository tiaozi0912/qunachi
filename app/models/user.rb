class User < ActiveRecord::Base
  attr_accessible :username, :email, :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count, :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip, :password, :password_confirmation

  acts_as_authentic do |c|
  	# pass config option if any
  	c.login_field = 'email'
  end
end
