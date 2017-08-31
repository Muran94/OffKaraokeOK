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
#  prefecture_id      :integer
#

FactoryGirl.define do
  factory :article do
    title 'カラオケオフ会開催！（8/31）'
    text '新宿hogehoge店にてカラオケオフ会を開催いたします！'
    application_period '2017-08-31 13:52:23'
    capacity 10
    venue 'カラオケ館hogehoge店'
    budget 3000 # 予算
  end
end
