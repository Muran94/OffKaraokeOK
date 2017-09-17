class ParticipantsController < ApplicationController
  before_action :authenticate_user!

  def create
    @participant = Participant.find_or_initialize_by(user_id: current_user.id, article_id: params[:article_id])
    if @participant.new_record?
      if @participant.save
        render json: { delete_path: article_participant_path(@participant.article, @participant), status: :created }
      else
        render json: { status: :unprocessable_entity }
      end
    else
      render json: { delete_path: article_participant_path(@participant.article, @participant), status: 'already_participated' }
    end
  end

  def destroy
    @participant = Participant.where(user_id: current_user.id, article_id: params[:article_id]).first
    if @participant.present?
      @participant.delete
      render json: { post_path: article_participants_path(@participant.article), status: 'resign_completed' }
    else
      render json: { status: 'already_resigned' }
    end
  end
end
