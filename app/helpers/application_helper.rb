# frozen_string_literal: true
module ApplicationHelper
  def current_page_article_index_page?
    controller.controller_name == "articles" && controller.action_name == "index"
  end

  def current_page_article_new_page?
    controller.controller_name == "articles" && controller.action_name == "new"
  end

  def current_page_my_page?
    controller.controller_name == "my_page"
  end

  def current_page_user_registration_page?
    controller.controller_name == "registrations" && controller.action_name == "new"
  end

  def current_page_user_login_page?
    controller.controller_name == "sessions" && controller.action_name == "new"
  end
end
