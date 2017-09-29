# frozen_string_literal: true
# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  text       :text
#  read_count :integer
#  article_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :article

  TEXT_MAXIMUM_LENGTH = 1000
  validates :text, presence: true, length: { maximum: TEXT_MAXIMUM_LENGTH }

  # メッセージ投稿主のUserオブジェクトを返す
  def owner
    User.find(user_id) if user_id.present?
  end
end
