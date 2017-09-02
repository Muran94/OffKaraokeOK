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
#  budget             :integer
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
    application_period Time.zone.now
    event_date 2.days.from_now
    capacity 10
    budget 3000 # 予算
  end
end
