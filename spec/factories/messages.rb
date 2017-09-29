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

FactoryGirl.define do
  factory :message do
    sequence :text do |num|
      "メッセージ本文#{num}"
    end
    association :article
  end
end
