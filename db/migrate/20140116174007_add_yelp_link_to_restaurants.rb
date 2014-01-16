class AddYelpLinkToRestaurants < ActiveRecord::Migration
  def change
  	add_column :restaurants, :yelp_link, :text
  end
end
