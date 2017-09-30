# frozen_string_literal: true
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

class Participant < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :user_id, presence: true
  validates :article_id, presence: true

  after_create :_send_participation_application_completed_notify_mail

  private

  def _send_participation_application_completed_notify_mail
    EventMailer.participation_application_completed_notify(self).deliver_now
  end
end
