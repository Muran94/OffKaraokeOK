require 'rails_helper'

RSpec.describe EventLotteryJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  let!(:article) { create(:article, :with_2_participant, capacity: 2) }

  after { clear_enqueued_jobs }

  context '実行確認テスト' do
    context 'perform_later' do
      it 'ジョブがキューされること' do
        expect { EventLotteryJob.perform_later(article) }.to have_enqueued_job(EventLotteryJob)
      end
    end

    context 'perform_now' do
      context 'ジョブが実行されること' do
        before { EventLotteryJob.perform_now(article) }

        it '抽選により２名の当選者と１名の落選者がでること' do
          expect(article.get_winners.count).to eq 2
          expect(article.get_rejected_people.count).to eq 1
        end
        it '抽選結果に関するメールが２通送信されること' do
          expect(ActionMailer::Base.deliveries.size).to eq 2
        end
      end
    end
  end

  context '実行時間テスト' do
    let(:application_period) { 1.minute.from_now }
    let(:article) { create(:article, :with_2_participant, application_period: application_period) }
    it '指定時間のキューにセットされる' do
      expect do
        EventLotteryJob.set(wait_until: application_period).perform_later(article)
      end.to have_enqueued_job.with(article).at(application_period)
    end
  end
end
