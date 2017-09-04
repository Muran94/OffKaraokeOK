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

# JpPrefecture関連フィールド
# prefecture_code     :integer

class Article < ActiveRecord::Base
  include JpPrefecture

  belongs_to :user
  has_many :participants
  jp_prefecture :prefecture_code

  # 投稿タイトル
  TITLE_MAXIMUM_LENGTH = 100
  validates :title, presence: true, length: { maximum: TITLE_MAXIMUM_LENGTH }
  # 投稿本文
  TEXT_MAXIMUM_LENGTH = 2000
  validates :text, presence: true, length: { maximum: TEXT_MAXIMUM_LENGTH }
  # 会場
  VENUE_MAXIMUM_LENGTH = 50
  validates :venue, presence: true, length: { maximum: VENUE_MAXIMUM_LENGTH }
  # 都道府県コード
  validates :prefecture_code, inclusion: JpPrefecture::Prefecture.all.map(&:code)
  # 応募締切日時
  validates :application_period, presence: true
  # 開催日
  validates :event_date, presence: true
  # 定員
  validates :capacity, numericality: true
  # 予算
  validates :budget, numericality: true
end
