# == Schema Information
#
# Table name: article_inquiries
#
#  id         :integer          not null, primary key
#  text       :text
#  user_id    :integer
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Article::Inquiry < ApplicationRecord
  belongs_to :user_id
  belongs_to :article_id

  validates :text, presence: true, length: { maximum: 500 }
end
