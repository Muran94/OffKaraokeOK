# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  introduction           :text
#  sex                    :string
#  birthday               :date
#  nickname               :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :favorites, dependent: :destroy

  before_validation :_convert_empty_values

  # ニックネーム
  NICKNAME_MAXIMUM_LENGTH = 50
  validates :nickname, presence: true, length: { maximum: NICKNAME_MAXIMUM_LENGTH }
  # 性別
  SEX_OPTIONS = { '男性' => 'male', '女性' => 'female' }.freeze
  validates :sex, inclusion: { in: SEX_OPTIONS.values }, allow_nil: true
  # 自己紹介
  INTRODUCTION_MAXIMUM_LENGTH = 1000
  validates :introduction, length: { maximum: INTRODUCTION_MAXIMUM_LENGTH }

  def owner?(model_object)
    # model_objectが空か、user_idフィールドを持たない場合はfalseを返す
    return false if model_object.blank? || !model_object.try(:user_id)
    id == model_object.user_id
  end

  def not_owner?(model_object)
    !owner?(model_object)
  end

  # すでに参加済みか？
  def already_participated?(article)
    return false if article.blank?
    participants.where(article_id: article.id).any?
  end

  # 既にお気に入り登録済みか
  def already_added_to_favorite?(article)
    Favorite.where(user_id: id, article_id: article.id).any?
  end

  private

  def _convert_empty_values
    self.sex = nil if sex.blank?
  end
end
