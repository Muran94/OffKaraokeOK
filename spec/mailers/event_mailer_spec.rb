require 'rails_helper'
require 'shared_examples/mailers/event_mailer_spec_shared_examples'

RSpec.describe EventMailer, type: :mailer do
  describe '#participation_application_completed_notify' do
    let(:user) { create(:user) }
    let(:article) { create(:article) }
    let(:participant) { create(:participant, user: user, article: article) }
    let(:mail) { EventMailer.participation_application_completed_notify(participant) }

    it_behaves_like '表題・送信元・送信先が全て正しいこと' do
      let(:target_subject) { Settings.mailer.event.participation_application_completed_notify.subject }
      let(:target_from) { Settings.mailer.event.from }
      let(:targeto_to) { user.email }
    end

    it_behaves_like '本文の中身に特定の値が含まれること' do
      let(:target_contents) do
        [
          "#{user.nickname}様",
          "#{article.title}への参加申請が完了しました！"
        ]
      end
    end
  end

  describe '#notify_result_of_lottery_to_winners' do
    let(:winners) { create_list(:user, 5) }
    let(:mail) { EventMailer.notify_result_of_lottery_to_winners(winners) }

    it_behaves_like '表題・送信元・送信先が全て正しいこと' do
      let(:target_subject) { Settings.mailer.event.notify_result_of_lottery_to_winners.subject }
      let(:target_from) { Settings.mailer.event.from }
      let(:targeto_to) { winners.pluck(:email) }
    end

    it_behaves_like '本文の中身に特定の値が含まれること' do
      let(:target_contents) do
        [
          '当選のお知らせ',
          '当選者一覧',
          winners.first.nickname,
          winners.second.nickname
        ]
      end
    end
  end

  describe '#notify_result_of_lottery_to_rejected_people' do
    let(:rejected_people) { create_list(:user, 5) }
    let(:mail) { EventMailer.notify_result_of_lottery_to_rejected_people(rejected_people) }

    it_behaves_like '表題・送信元・送信先が全て正しいこと' do
      let(:target_subject) { Settings.mailer.event.notify_result_of_lottery_to_rejected_people.subject }
      let(:target_from) { Settings.mailer.event.from }
      let(:targeto_to) { rejected_people.pluck(:email) }
    end

    it_behaves_like '本文の中身に特定の値が含まれること' do
      let(:target_contents) do
        [
          '落選のお知らせ',
          rejected_people.first.nickname,
          rejected_people.second.nickname
        ]
      end
    end
  end

  describe '#event_holding_reminder' do
    let(:winners) { create_list(:user, 5) }
    let(:mail) { EventMailer.event_holding_reminder(winners) }

    it '表題・送信元・送信先が全て正しいこと' do
      aggregate_failures do
        expect(mail).to have_subject Settings.mailer.event.event_holding_reminder.subject
        expect(mail).to be_delivered_from Settings.mailer.event.from
        expect(mail).to be_delivered_to winners.pluck(:email)
      end
    end

    it '本文の中身に特定の値が含まれること' do
      aggregate_failures do
        expect(mail).to have_body_text '前日リマインド'
        expect(mail).to have_body_text '参加者一覧'
        expect(mail).to have_body_text winners.first.nickname
        expect(mail).to have_body_text winners.second.nickname
      end
    end

    it_behaves_like '表題・送信元・送信先が全て正しいこと' do
      let(:target_subject) { Settings.mailer.event.event_holding_reminder.subject }
      let(:target_from) { Settings.mailer.event.from }
      let(:targeto_to) { winners.pluck(:email) }
    end

    it_behaves_like '本文の中身に特定の値が含まれること' do
      let(:target_contents) do
        [
          '前日リマインド',
          '参加者一覧',
          winners.first.nickname,
          winners.second.nickname
        ]
      end
    end
  end
end
