class Message < ApplicationRecord
  belongs_to :article

  TEXT_MAXIMUM_LENGTH = 1000
  validates :text, presence: true, length: { maximum: TEXT_MAXIMUM_LENGTH }

  def owner
    User.find(user_id) if user_id.present?
  end
end
