# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :basic_auth

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image, :nickname, :birthday, :sex, :introduction])
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == 'Kekkai' && pass == 'k7BxvDEyUnG3pJqvrWgvJFIRiS68X0pTzonyqHhNP4HlPcE2Vf'
    end
  end
end
