class ChangeCityName < ActiveRecord::Migration
  def change
  	rename_column :restaurants, :city, :city_name
  	rename_column :restaurants, :category, :category_name
  end
end
