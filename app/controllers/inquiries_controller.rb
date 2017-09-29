# frozen_string_literal: true
class InquiriesController < ApplicationController
  before_action :_inquiry_params

  def create
    @inquiry = Inquiry.new(_inquiry_params)
    if @inquiry.save
      render json: { status: :created }
    else
      render json: { data: @inquiry.errors.messages, status: :unprocessable_entity }
    end
  end

  private

  def _inquiry_params
    params.require(:inquiry).permit(:inquirers_email, :type, :message)
  end
end
