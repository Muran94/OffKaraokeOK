# frozen_string_literal: true
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
#  participation_cost :integer
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

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "article_#{Rails.env}"

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
  CAPACITY_MINIMUM_VALUE = 2
  CAPACITY_MAXIMUM_VALUE = 1000
  validates :capacity, numericality: { greater_than_or_equal_to: CAPACITY_MINIMUM_VALUE, less_than: CAPACITY_MAXIMUM_VALUE }
  # 参加費
  PARTICIPATION_COST_MINIMUM_VALUE = 0
  PARTICIPATION_COST_MAXIMUM_VALUE = 100_000
  validates :participation_cost, numericality: { greater_than_or_equal_to: PARTICIPATION_COST_MINIMUM_VALUE, less_than: PARTICIPATION_COST_MAXIMUM_VALUE }

  def execute_lottery
    elected_participants_count = participants.where(elected: true).count
    winners = participants.where(elected: false).order('RANDOM()').limit(capacity - elected_participants_count)
    winners.each { |winner| winner.update(elected: true) }
    User.find(winners.pluck(:user_id))
  end

  def get_winners
    User.find(participants.where(elected: true).pluck(:user_id))
  end

  def get_rejected_people
    User.find(participants.where(elected: false).pluck(:user_id))
  end

  # インデクシング時に呼び出されるメソッド
  # マッピングのデータを返すようにする
  def as_indexed_json(_options = {})
    attributes
      .symbolize_keys
      .slice(:title, :text, :application_period, :capacity, :venue, :participation_cost, :event_date, :prefecture_code)
  end

  def self.search(search_conditions = {})
    search_definition = Elasticsearch::DSL::Search.search do
      query do
        if search_conditions.present? && search_conditions.values.any?(&:present?)
          filtered do
            if search_conditions.dig(:keyword).present?
              query do
                multi_match do
                  query search_conditions.dig(:keyword)
                  fields %w(title text)
                end
              end
            end
            if search_conditions.dig(:prefecture_code).present?
              filter do
                term prefecture_code: search_conditions.dig(:prefecture_code)
              end
            end
          end
        else
          match_all
        end
      end
      size '10000'
    end

    __elasticsearch__.search(search_definition)
  end

  private

  # 抽選ジョブのエンキュー
  def _draw_lots
    EventLotteryJob.set(wait_until: application_period).perform_later(self)
  end

  # 投稿者を参加者に含める。また、自動で当選状態にする
  def _add_owner_to_participant
    # 投稿者には参加完了メールを送信したくないのでコールバックを飛ばす
    Participant.skip_callback(:create, :after, :_send_participation_application_completed_notify_mail)
    participants.create(user_id: user_id, elected: true)
    Participant.set_callback(:create, :after, :_send_participation_application_completed_notify_mail)
  end
end
