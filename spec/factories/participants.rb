# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :integer
#  elected    :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :participant do
    association :user
    association :article

    trait :elected do
      elected true
    end
  end
end
