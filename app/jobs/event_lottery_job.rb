# frozen_string_literal: true
class EventLotteryJob < ApplicationJob
  queue_as :default

  def perform(article)
    winners = article.execute_lottery # 抽選実行
    rejected_people = article.get_rejected_people
    # 当選者への抽選結果のメール送信処理
    EventMailer.notify_result_of_lottery_to_winners(winners).deliver
    # 当選者へのイベント前日リマインド
    EventMailer.event_holding_reminder(winners).deliver_later(wait_until: article.event_date - 1.day)

    # 落選者への抽選結果のメール送信処理
    EventMailer.notify_result_of_lottery_to_rejected_people(rejected_people).deliver
  end
end
