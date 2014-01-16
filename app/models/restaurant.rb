class Restaurant < ActiveRecord::Base
  ### state, zip should never be used ###
  attr_accessible :address, :category_name, :city_name, :description, :labels, :name, :phone, :rating, :secondary_name, :state, :zip

  validates :name, :presence => true
  validates :city_name, :presence => true

  belongs_to :city, :primary_key => :name, :foreign_key => :city_name
  belongs_to :category, :primary_key => :name, :foreign_key => :category_name

  def to_json 
    @city = city
  	{
  		:category => category_name,
  		:city => city_name,
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

  def self.search keywords
    self.where("category_name iLIKE ? or city_name iLIKE ? or name iLIKE ?", "%#{keywords}%", "%#{keywords}%", "%#{keywords}%")
  end

  def self.recommend city, category, excluded_restaurants
    res = self.search(category).concat(self.search(city))
    #puts excluded_restaurants.map(&:id)
    res.reject {|r| excluded_restaurants.map(&:id).include?(r.id)}
  end
end
