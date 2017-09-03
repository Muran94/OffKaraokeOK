class MyPageController < ApplicationController
  before_action :authenticate_user!

  def profile
  end

  def participating_event
    @participating_events = current_user.participants
  end
end
