# frozen_string_literal: true
class MyPageController < ApplicationController
  before_action :authenticate_user!

  def profile; end

  def articles
    @articles = current_user.articles
  end

  def favorites
    @favorites = Article.includes(:user).find(current_user.favorites.pluck(:article_id))
  end

  def participations
    @participations = Article.includes(:user).find(current_user.participants.pluck(:article_id))
  end
end
