# frozen_string_literal: true
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

class Inquiry < ApplicationRecord
  # この行を追加しないとtypeフィールドが使えない。
  # ActiveRecordの仕組み上エラーが発生する。
  self.inheritance_column = :_type_disabled

  # 問い合わせ者のメールアドレス
  INQUIRERS_EMAIL_REGEXP = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  validates :inquirers_email, presence: true, format: { with: INQUIRERS_EMAIL_REGEXP }

  # 問い合わせの種類
  TYPE_OPTIONS = {
    'ご質問' => 1,
    'ご意見・ご要望' => 2,
    '不具合報告' => 3
  }.freeze
  validates :type, inclusion: TYPE_OPTIONS.values

  # 問い合わせ内容
  MESSAGE_MAXIMUM_LENGTH = 1000
  validates :message, presence: true, length: { maximum: MESSAGE_MAXIMUM_LENGTH }
end
