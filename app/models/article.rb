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
  has_many :participants, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :messages, dependent: :destroy
  jp_prefecture :prefecture_code

  after_create :_draw_lots, :_add_owner_to_participant

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
  CAPACITY_BOTTOM_LINE = 2
  validates :capacity, numericality: { greater_than_or_equal_to: CAPACITY_BOTTOM_LINE }
  # 予算
  validates :budget, numericality: { greater_than_or_equal_to: 0 }

  def execute_lottery
    winners = participants.order('RANDOM()').limit(capacity)
    winners.each { |winner| winner.update(elected: true) }
    User.find(winners.pluck(:user_id))
  end

  def get_winners
    User.find(participants.where(elected: true).pluck(:user_id))
  end

  def get_rejected_people
    User.find(participants.where(elected: false).pluck(:user_id))
  end

  private

  def _draw_lots
    EventLotteryJob.set(wait_until: application_period).perform_later(self)
  end

  def _add_owner_to_participant
    # 投稿者には参加完了メールを送信したくないのでコールバックを飛ばす
    Participant.skip_callback(:create, :after, :_send_participation_application_completed_notify_mail)
    participants.create(user_id: user_id)
    Participant.set_callback(:create, :after, :_send_participation_application_completed_notify_mail)

  end
end
