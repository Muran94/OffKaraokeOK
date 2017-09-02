# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Participant < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :user_id, presence: true
  validates :article_id, presence: true
end
