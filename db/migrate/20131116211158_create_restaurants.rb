class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name, :null => false
      t.string :city
      t.string :state
      t.string :address
      t.string :secondary_name
      t.string :phone
      t.string :category
      t.string :labels
      t.string :description
      t.string :zip
      t.integer :rating

      t.timestamps
    end

    add_index :restaurants, :name
    add_index :restaurants, [:city, :category, :rating]
  end
end
