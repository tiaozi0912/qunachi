class City < ActiveRecord::Base
  attr_accessible :name, :state, :zip

  has_many :restaurants, :dependent => :destroy, :primary_key => :name, :foreign_key => :city

  def to_json
  	{
  		:name => name
  	}
  end
end
