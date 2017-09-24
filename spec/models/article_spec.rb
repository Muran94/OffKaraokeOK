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
#  participation_cost             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  event_date         :datetime
#  user_id            :integer
#  prefecture_code    :integer
#

require 'rails_helper'

# spec内で使われてるshared_examplesはこのファイル内で定義
require 'shared_examples/model_spec_shared_examples'
require 'shared_examples/models/article_spec_shared_examples'

RSpec.describe Article, type: :model do
  context '関連付け' do
    context 'dependent' do
      let!(:article) { create(:article) }

      it 'Articleが削除されたらそれに紐づくParticipantも削除する' do
        expect { article.destroy }.to change(Participant, :count).by(-1)
      end
    end
  end

  context 'バリデーション' do
    context '投稿タイトル' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :title }
        end
      end

      context 'length検証(maximum)' do
        it_behaves_like '値の長さが上限値以下であれば通る' do
          let(:model_object) { :article }
          let(:field_name) { :title }
          let(:max_length) { Article::TITLE_MAXIMUM_LENGTH }
        end
        it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
          let(:model_object) { :article }
          let(:field_name) { :title }
          let(:max_length) { Article::TITLE_MAXIMUM_LENGTH }
        end
      end
    end

    context '投稿本文' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :text }
        end
      end
      context 'length検証(maximum)' do
        it_behaves_like '値の長さが上限値以下であれば通る' do
          let(:model_object) { :article }
          let(:field_name) { :text }
          let(:max_length) { Article::TEXT_MAXIMUM_LENGTH }
        end
        it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
          let(:model_object) { :article }
          let(:field_name) { :text }
          let(:max_length) { Article::TEXT_MAXIMUM_LENGTH }
        end
      end
    end

    context '会場' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :venue }
        end
      end
      context 'length検証(maximum)' do
        it_behaves_like '値の長さが上限値以下であれば通る' do
          let(:model_object) { :article }
          let(:field_name) { :venue }
          let(:max_length) { Article::VENUE_MAXIMUM_LENGTH }
        end
        it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
          let(:model_object) { :article }
          let(:field_name) { :venue }
          let(:max_length) { Article::VENUE_MAXIMUM_LENGTH }
        end
      end
    end

    context '都道府県コード' do
      context 'inclusion検証' do
        before do
          article.valid?
          expect(article.errors.messages[:prefecture_code]).to match_array ['is not included in the list']
        end

        context 'nilが与えられた時' do
          let(:article) { build(:article, prefecture_code: nil) }

          it 'バリデーションに引っかかること' do
          end
        end
        context '空文字が与えられた時' do
          let(:article) { build(:article, prefecture_code: '') }

          it 'バリデーションに引っかかること' do
          end
        end
        context '文字列が与えられた時' do
          let(:article) { build(:article, prefecture_code: 'something') }

          it 'バリデーションに引っかかること' do
          end
        end
        context 'リスト（1 ~ 47)以外の数値が与えられた時' do
          let(:article) { build(:article, prefecture_code: 100) }

          it 'バリデーションに引っかかること' do
          end
        end
      end
    end

    context '応募締切日' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :application_period }
        end
      end
    end

    context '開催日' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :event_date }
        end
      end
    end

    context '定員' do
      context 'numericality検証' do
        it_behaves_like '整数値以外の時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :capacity }
        end

        context "定員が#{Article::CAPACITY_MINIMUM_VALUE - 1}人未満の時" do
          let(:article) { build(:article, capacity: Article::CAPACITY_MINIMUM_VALUE - 1) }
          it 'バリデーションに引っかかること' do
            article.valid?
            expect(article.errors.messages[:capacity]).to include "must be greater than or equal to #{Article::CAPACITY_MINIMUM_VALUE}"
          end
        end

        context "定員が#{Article::CAPACITY_MINIMUM_VALUE}人以上#{Article::CAPACITY_MAXIMUM_VALUE - 1}人未満の時" do
          it '通ること' do
            article = build(:article, capacity: Article::CAPACITY_MINIMUM_VALUE)
            expect(article.valid?).to be true
          end
          it '通ること' do
            article = build(:article, capacity: Article::CAPACITY_MAXIMUM_VALUE - 1)
            expect(article.valid?).to be true
          end
        end

        context "定員が#{Article::CAPACITY_MAXIMUM_VALUE}人以上の時" do
          let(:article) { build(:article, capacity: Article::CAPACITY_MAXIMUM_VALUE) }
          it 'バリデーションに引っかかること' do
            article.valid?
            expect(article.errors.messages[:capacity]).to include "must be less than #{Article::CAPACITY_MAXIMUM_VALUE}"
          end
        end
      end
    end

    context '参加費' do
      context 'numericality検証' do
        it_behaves_like '整数値以外の時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :participation_cost }
        end

        it_behaves_like '負の数の時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :participation_cost }
        end
      end

      context "参加費が#{Article::PARTICIPATION_COST_MINIMUM_VALUE - 1}円未満の時" do
        let(:article) { build(:article, participation_cost: Article::PARTICIPATION_COST_MINIMUM_VALUE - 1) }
        it 'バリデーションに引っかかること' do
          article.valid?
          expect(article.errors.messages[:participation_cost]).to include "must be greater than or equal to #{Article::PARTICIPATION_COST_MINIMUM_VALUE}"
        end
      end

      context "参加費が#{Article::PARTICIPATION_COST_MINIMUM_VALUE}人以上#{Article::PARTICIPATION_COST_MAXIMUM_VALUE - 1}円未満の時" do
        it '通ること' do
          article = build(:article, participation_cost: Article::PARTICIPATION_COST_MINIMUM_VALUE)
          expect(article.valid?).to be true
        end
        it '通ること' do
          article = build(:article, participation_cost: Article::PARTICIPATION_COST_MAXIMUM_VALUE - 1)
          expect(article.valid?).to be true
        end
      end

      context "参加費が#{Article::PARTICIPATION_COST_MAXIMUM_VALUE}円以上の時" do
        let(:article) { build(:article, participation_cost: Article::PARTICIPATION_COST_MAXIMUM_VALUE) }
        it 'バリデーションに引っかかること' do
          article.valid?
          expect(article.errors.messages[:participation_cost]).to include "must be less than #{Article::PARTICIPATION_COST_MAXIMUM_VALUE}"
        end
      end
    end
  end

  context 'コールバック' do
    # 抽選
    context '#_draw_lots' do
      before { create(:article) }
      it '抽選結果の報告メールがキューされること' do
        expect(enqueued_jobs.size).to eq 1
      end
    end
  end

  context 'メソッド' do
    context '#execute_lottery' do
      before { article.execute_lottery }
      let(:article) { create(:article, :with_2_participant, capacity: capacity) } # ３件の参加申請を持つ投稿

      context '参加申請数が定員を満たなかったら' do
        let(:capacity) { 4 } # 定員３人

        it_behaves_like '当選者と落選者の人数が正しいこと' do
          let(:expected_winner_count) { 3 }
          let(:expected_rejected_people_count) { 0 }
        end
      end

      context '参加申請数がちょうど定員と同じ数だったら' do
        let(:capacity) { 3 }

        it_behaves_like '当選者と落選者の人数が正しいこと' do
          let(:expected_winner_count) { 3 }
          let(:expected_rejected_people_count) { 0 }
        end
      end

      context '参加申請数が定員を超えたら' do
        let(:capacity) { 2 }

        it_behaves_like '当選者と落選者の人数が正しいこと' do
          let(:expected_winner_count) { 2 }
          let(:expected_rejected_people_count) { 1 }
        end
      end
    end

    context '#get_winners' do
      let(:article) { create(:article) }
      let(:user) { create(:user) }

      context '当選者が１人以上いる場合' do
        let!(:participant) { create(:participant, :elected, user: user, article: article) }

        it '当選者のUserオブジェクトを含む配列を返すこと' do
          expect(article.get_winners).to match_array([user])
        end
      end
      context '当選者が１人もいない場合' do
        let(:participant) { create(:participant, user: user, article: article) }

        it '空配列を返すこと' do
          expect(article.get_winners).to match_array([])
        end
      end
    end

    context '#get_rejected_people' do
      let(:article) { create(:article) }

      context '落選者が１人以上いる場合' do
        it '当選者のUserオブジェクトを含む配列を返すこと' do
          expect(article.get_rejected_people).to match_array([article.user])
        end
      end
      context '当選者が１人もいない場合' do
        let(:participant) { create(:participant, :elected, user: user, article: article) }

        it '空配列を返すこと' do
          expect(article.get_winners).to match_array([])
        end
      end
    end
  end
end
