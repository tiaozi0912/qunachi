class Restaurant < ActiveRecord::Base
  attr_accessible :address, :category, :city, :description, :labels, :name, :phone, :rating, :secondary_name, :state, :zip

  validates :name, :presence => true

  belongs_to :city, :primary_key => :name, :foreign_key => :city

  def to_json 
    @city = city
  	{
  		:category => category,
  		:city => @city.name,
  		:description => description,
  		:id => id,
  		:name => name,
  		:address => address,
  		:state => @city.state,
  		:zip => @city.zip,
  		:secondary_name => secondary_name,
  		:rating => rating, 
  		:labels => labels
  	}
  end
end
