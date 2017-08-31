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
    if @article.save
      redirect_to @article
    else
      flash[:alert] = '投稿に失敗しました。'
      render "new"
    end
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
      :title,               # タイトル
      :text,                # 投稿本文
      :venue,               # 会場
      :event_date,          # 開催日
      :application_period,  # 応募締切日
      :capacity,            # 定員
      :budget               # 予算
    )
  end
end
