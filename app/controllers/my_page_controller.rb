class MyPageController < ApplicationController
  before_action :authenticate_user!

  def profile
    @participating_events = current_user.participants
  end
end
