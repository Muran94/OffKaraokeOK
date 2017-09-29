# frozen_string_literal: true
class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    @articles = @user.articles.page(params[:page])
  end
end
