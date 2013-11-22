class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :state
      t.string :zip

      t.timestamps
    end

    add_index :cities, [:name, :state]
  end
end
