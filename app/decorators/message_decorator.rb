# frozen_string_literal: true
module MessageDecorator
  def is_mine?
    return false if current_user.blank?
    current_user.id == user_id
  end

  def format_user_nickname
    return '名無しさん' if user_id.blank?
    User.find(user_id).nickname
  end
end
