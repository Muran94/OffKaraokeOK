# frozen_string_literal: true
class MessagesController < ApplicationController
  before_action :_get_article

  def index
    @article = Article.find(params[:article_id])
    @messages = @article.messages.all.order('created_at DESC')
    @new_message = @article.messages.build
  end

  def create
    @new_message = @article.messages.build(_message_params)
    @new_message.user_id = current_user.id if current_user.present?
    flash[:error] = 'メッセージの送信に失敗しました' unless @new_message.save
    redirect_to article_messages_path(@article)
  end

  private

  def _message_params
    params.require(:message).permit(:text)
  end

  def _get_article
    @article = Article.find(params[:article_id])
  end
end
