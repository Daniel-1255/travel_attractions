class AttractionsController < ApplicationController
  def index
    @attractions = Attraction.joins(:attraction_categories).where(attraction_categories: {category_api_id: params[:category_api_id]})
    @category = Category.find_by_api_id(params[:category_api_id])
  end

  def show
    @attraction = Attraction.find_by_api_id(params[:id])
  end
end
