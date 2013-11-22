class Restaurant < ActiveRecord::Base
  attr_accessible :address, :category, :city, :description, :labels, :name, :phone, :rating, :secondary_name, :state, :zip

  validates :name, :presence => true

  def to_json 
  	{
  		:category => category,
  		:city => city,
  		:description => description,
  		:id => id,
  		:name => name,
  		:address => address,
  		:state => state,
  		:zip => zip,
  		:secondary_name => secondary_name,
  		:rating => rating, 
  		:labels => labels
  	}
  end
end
