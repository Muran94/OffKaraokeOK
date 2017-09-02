class ParticipantsController < ApplicationController
  before_action :_get_article, only: [:create, :destroy]
  before_action :authenticate_user!

  def create
    @participant = Participant.new(user_id: current_user.id, article_id: @article.id)
    if @participant.save
      redirect_to @article, flash: {notice: "参加申請が完了しました。"}
    else
      redirect_to @article, flash: {alert: "参加に失敗しました。"}
    end
  end

  def destroy
    @participant = Participant.where(user_id: current_user.id, article_id: @article.id).first
    @participant.delete
    flash[:notice] = "参加を辞退しました。"
    redirect_to @article
  end

  private

    def _get_article
      @article = Article.find(params[:article_id])
    end
end
