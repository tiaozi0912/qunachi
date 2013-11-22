class Category < ActiveRecord::Base
  attr_accessible :name

  def to_json
  	{
  		:name => name,
  		:id => id
  	}
  end
end
