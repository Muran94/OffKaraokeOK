class UserReportsController < ApplicationController
  def new
    @user_report = UserReport.new
  end

  def create
    @user_report = UserReport.new(_user_report_params)

    if @user_report.save
      flash[:notice] = '通報が完了しました。ご協力ありがとうございました。'
      redirect_to profile_path(@user_report.user)
    else
      flash[:alert] = '通報に失敗しました。'
      render :new
    end
  end

  private

  def _user_report_params
    params.require(:user_report).permit(:text, :user_id)
  end
end
