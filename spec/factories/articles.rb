# == Schema Information
#
# Table name: articles
#
#  id                 :integer          not null, primary key
#  title              :string
#  text               :text
#  application_period :datetime
#  capacity           :integer
#  venue              :string
#  participation_cost             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  event_date         :datetime
#  user_id            :integer
#  prefecture_code    :integer
#

FactoryGirl.define do
  factory :article do
    association :user

    title 'カラオケオフ会開催！'
    text '新宿hogehoge店にてカラオケオフ会を開催いたします！'
    venue 'カラオケ館hogehoge店'
    prefecture_code 13 # 東京
    application_period 1.day.from_now
    event_date 2.days.from_now
    capacity 10
    participation_cost 3000 # 参加費

    trait :with_2_participant do
      after(:create) do |article|
        create_list(:participant, 2, article: article)
      end
    end
  end
end
