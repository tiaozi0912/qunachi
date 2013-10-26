class UserSession < Authlogic::Session::Base
	attr_accessor :password, :email, :remember_me
  # configuration here, see documentation for sub modules of Authlogic::Session
  def to_key 
  	new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  def persisted?
  	false	
  end
end