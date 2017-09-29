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

FactoryGirl.define do
  factory :user_report do
    association :user

    text '通報しますた'
  end
end
