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
#

# JpPrefecture関連フィールド
# prefecture_code     :integer

class Article < ApplicationRecord
  include JpPrefecture

  belongs_to :user
  jp_prefecture :prefecture_code

  validates :title, presence: true
  validates :text, presence: true, length: { maximum: 1000 }
  validates :venue, presence: true
  validates :event_date, presence: true
  validates :application_period, presence: true
  validates :capacity, presence: true, numericality: true
  validates :budget, presence: true, numericality: true
end
