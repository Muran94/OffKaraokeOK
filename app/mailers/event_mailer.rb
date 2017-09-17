class EventMailer < ApplicationMailer
  default from: Settings.mailer.event.from # config/settings.ymlに定数として定義

  # 参加申請完了通知メール
  def participation_application_completed_notify(participant)
    @user = participant.user
    @article = participant.article
    mail(to: @user.email, subject: Settings.mailer.event.participation_application_completed_notify.subject)
  end

  # 当選者へのお知らせメール
  def notify_result_of_lottery_to_winners(winners)
    @winners = winners
    mail(to: @winners.pluck(:email), subject: Settings.mailer.event.notify_result_of_lottery_to_winners.subject)
  end

  # 落選者へのお知らせメール
  def notify_result_of_lottery_to_rejected_people(rejected_people)
    @rejected_people = rejected_people
    mail(to: @rejected_people.pluck(:email), subject: Settings.mailer.event.notify_result_of_lottery_to_rejected_people.subject)
  end

  # イベントの前日リマインドメール
  def event_holding_reminder(winners)
    @winners = winners
    mail(to: @winners.pluck(:email), subject: Settings.mailer.event.event_holding_reminder.subject)
  end
end
