class ChangeCityName < ActiveRecord::Migration
  def change
  	rename_column :restaurants, :city, :city_name
  end
end
