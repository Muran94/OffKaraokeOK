# frozen_string_literal: true
# == Schema Information
#
# Table name: user_reports
#
#  id         :integer          not null, primary key
#  text       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserReport < ApplicationRecord
  belongs_to :user

  # 通報内容
  TEXT_MAXIMUM_LENGTH = 1000
  validates :text, presence: true, length: { maximum: TEXT_MAXIMUM_LENGTH }
end
