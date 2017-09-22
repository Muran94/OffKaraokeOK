class ArticlesController < ApplicationController
  before_action :_get_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @articles = Article.all.order('created_at DESC').page(params[:page])
  end

  def show
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(_get_article_params)
    if @article.save
      flash[:notice] = '記事を投稿しました。'
      redirect_to @article
    else
      flash[:alert] = '記事の投稿に失敗しました。'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @article.update(_get_article_params)
      flash[:notice] = '記事を更新しました。'
      redirect_to @article
    else
      flash[:alert] = '記事の更新に失敗しました。'
      render 'edit'
    end
  end

  def destroy
    @article.delete
    flash[:notice] = '記事を削除しました。'
    redirect_to my_page_articles_path
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
      :prefecture_code,     # 都道府県
      :event_date,          # 開催日
      :application_period,  # 応募締切日
      :capacity,            # 定員
      :participation_cost               # 参加費
    )
  end
end
