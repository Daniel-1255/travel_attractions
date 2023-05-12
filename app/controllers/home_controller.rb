class HomeController < ApplicationController
  def index
    # if table categories is empty, call the Open API to get category data
    existing_categories = Category.all
    
    if existing_categories.empty?
      api_params = URI.encode_www_form({type: "Attractions", pages: 1})
      uri = URI.parse("https://www.travel.taipei/open-api/ja/Miscellaneous/Categories?#{api_params}")
      response = Net::HTTP.get_response(uri, { 'Accept' => 'application/json' })
      result = JSON.parse(response.body)

      # save API data
      result["data"]["Category"].each do |category|
        # categoryのAPI idでそのデータがtableにすでに存在しているかを確認する
        existing_category = Category.find_by_api_id(category["id"])

        if existing_category.nil?
          Category.create( :api_id => category["id"],
                           :name => category["name"] )
        end
      end
    end

    @categories = Category.all
  end

  def search
    # Open APIからhome indexで選択したカテゴリーのAttractions dataを取得する
    api_params = URI.encode_www_form({categoryIds: params[:category][:id], pages: 1})    
    uri = URI.parse("https://www.travel.taipei/open-api/ja/Attractions/All?#{api_params}")
    response = Net::HTTP.get_response(uri, { 'Accept' => 'application/json' })
    result = JSON.parse(response.body)
    
    result["data"].each do |data|
      # attractionのAPI idでそのデータがtableにすでに存在しているかを確認する
      existing_attraction = Attraction.find_by_api_id( data["id"] )

      # image arrayの一番目の画像URLを保存する
      images_src = data["images"].present? ? data["images"][0]["src"] : ""

      if existing_attraction.nil?
        # table attractionsに保存する
        attraction = Attraction.create( :api_id => data["id"],
                           :name => data["name"],
                           :introduction => data["introduction"],
                           :zipcode => data["zipcode"],
                           :district => data["district"],
                           :address => data["address"],
                           :images_src => images_src )

        # table attraction_categoriesにattractionのカテゴリー資料(複数)を保存する
        data["category"].each do |category|
          attraction.attraction_categories.create( :attraction_api_id => data["id"],
                                                   :category_api_id => category["id"],
                                                   :name => category["name"] )
        end
      end

    end

    # attractions_pathに選択したカテゴリーの値をpassする
    redirect_to attractions_path(category_api_id: params[:category][:id])
  end
end
