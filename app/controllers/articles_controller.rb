class ArticlesController < ApplicationController
  before_action :_get_article, only: [:show, :edit, :destroy]
  def index
    @articles = Article.all.order('created_at DESC')
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(_get_article_params)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def _get_article
    @article = Article.find(params[:id])
  end

  def _get_article_params
    params.require(:article).permit(
      :title,
      :text,
      :application_period,
      :capacity,
      :venue,
      :budget
    )
  end
end
