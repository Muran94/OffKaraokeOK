class Message < ApplicationRecord
  belongs_to :article

  TEXT_MAXIMUM_LENGTH = 1000
  validates :text, presence: true, length: { maximum: TEXT_MAXIMUM_LENGTH }
end
