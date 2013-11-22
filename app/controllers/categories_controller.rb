class CategoriesController < ApplicationController

	def index
		render :json => Category.all.map {|c| c.to_json}
	end
end
