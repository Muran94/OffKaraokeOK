class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @articles = @user.articles.page(params[:page])
  end
end
