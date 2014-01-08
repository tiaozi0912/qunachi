class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :restaurants, :primary_key => :name, :foreign_key => :category_name

  def to_json
  	{
  		:name => name,
  		:id => id
  	}
  end
end
