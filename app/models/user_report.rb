class UserReport < ApplicationRecord
  belongs_to :user

  # 通報内容
  TEXT_MAXIMUM_LENGTH = 1000
  validates :text, presence: true, length: { maximum: TEXT_MAXIMUM_LENGTH }
end
