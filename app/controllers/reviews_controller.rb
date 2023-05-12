class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    # @reviews = Review.all;
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @attraction = Attraction.find_by_api_id(params[:attraction_id])
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    # レビューを新規投稿後attractionの詳細ページにredirectする
    if @review.save
      redirect_to attraction_path(@review.attraction.api_id), notice: "投稿しました"
    else
      attraction = Attraction.find(review_params[:attraction_id])
      redirect_to attraction_path(attraction.api_id), alert: @review.errors.full_messages.join("\n")
    end
  end

  def edit
    @review = Review.find(params[:id])
    if @review.user != current_user
      redirect_to attractions_path, alert: "不正なアクセスです。"
    end
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(title: review_params[:title],
                      body: review_params[:body])
      redirect_to review_path(@review), notice: "更新しました。"
    else
      render :edit
    end
  end

  def destroy
    review = Review.find(params[:id])
    if review.user != current_user
      redirect_to user_path(current_user.id), alert: "不正なアクセスです。"
    else
      review.destroy
      redirect_to user_path(current_user.id)
    end
  end

  private
  def review_params
    params.require(:review).permit(:attraction_id, :title, :body)
  end
end
