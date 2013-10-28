class AddAccessToken < ActiveRecord::Migration
  def change
  	add_column :users, :weibo_access_token, :string
  	add_column :users, :renren_access_token, :string
  	add_column :users, :facebook_access_token, :string
  	add_column :users, :instagram_access_token, :string
  	add_column :users, :weibo_uid, :string
  	add_column :users, :renren_uid, :string
  	add_column :users, :facebook_uid, :string
  	add_column :users, :instagram_uid, :string
  	add_index :users, [:weibo_access_token, :renren_access_token, :facebook_access_token, :instagram_access_token, :weibo_uid, :renren_uid, :facebook_uid, :instagram_uid, :email, :username], :unique => true, :name => 'users_index'
  end
end
