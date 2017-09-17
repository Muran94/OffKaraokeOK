class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @favorite = Favorite.find_or_initialize_by(user_id: current_user.id, article_id: params[:article_id])
    if @favorite.new_record?
      if @favorite.save
        render json: { delete_path: article_favorite_path(@favorite.article, @favorite), status: :created }
      else
        render json: { status: :unprocessable_entity }
      end
    else
      render json: { delete_path: article_favorite_path(@favorite.article, @favorite), status: 'already_added_to_favorite' }
    end
  end

  def destroy
    @favorite = Favorite.where(user_id: current_user.id, article_id: params[:article_id]).first
    if @favorite.present?
      @favorite.delete
      render json: { post_path: article_favorites_path(@favorite.article), status: 'deleted' }
    else
      render json: { post_path: article_favorites_path(@favorite.article), status: 'already_deleted' }
    end
  end
end
