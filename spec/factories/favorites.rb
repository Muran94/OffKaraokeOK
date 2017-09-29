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

FactoryGirl.define do
  factory :favorite do
    association :user
    association :article
  end
end
