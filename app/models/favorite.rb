# frozen_string_literal: true
# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  article_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Favorite < ApplicationRecord
  belongs_to :article
  belongs_to :user
end
