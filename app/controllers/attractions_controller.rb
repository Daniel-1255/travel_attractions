class AttractionsController < ApplicationController
  def index
    # attractionが属する複数のカテゴリーの中で指定したカテゴリーがある場合tableから取得する
    @attractions = Attraction.joins(:attraction_categories).where(attraction_categories: {category_api_id: params[:category_api_id]})
    @category = Category.find_by_api_id(params[:category_api_id])
  end

  def show
    # attractionの詳細ページはAPI Idで検索する
    @attraction = Attraction.find_by_api_id(params[:id])
  end
end
