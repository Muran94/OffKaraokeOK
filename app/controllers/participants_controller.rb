class ParticipantsController < ApplicationController
  before_action :authenticate_user!

  def create
    @participant = Participant.find_or_initialize_by(user_id: current_user.id, article_id: params[:article_id])
    if @participant.new_record?
      if @participant.save
        flash[:notice] = "参加申請が完了しました。"
      else
        flash[:alert] = "エラーにより参加できませんでした。"
      end
    else
      flash[:alert] = "既に参加済みです。"
    end
    redirect_to article_path(params[:article_id])
  end

  def destroy
    @participant = Participant.where(user_id: current_user.id, article_id: params[:article_id]).first
    if @participant.present?
      @participant.delete
      flash[:notice] = "参加を辞退しました。"
    else
      flash[:alert] = "既に辞退しています。"
    end
    redirect_to article_path(params[:article_id])
  end
end
