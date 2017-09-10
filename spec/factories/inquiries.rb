# == Schema Information
#
# Table name: inquiries
#
#  id              :integer          not null, primary key
#  inquirers_email :string
#  type            :integer
#  message         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :inquiry do
    inquirers_email { Faker::Internet.email }
    type 1 # ご質問
    message '質問お願いします。'
  end
end
