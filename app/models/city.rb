class City < ActiveRecord::Base
  attr_accessible :name, :state, :zip

  def to_json
  	{
  		:name => name
  	}
  end
end
