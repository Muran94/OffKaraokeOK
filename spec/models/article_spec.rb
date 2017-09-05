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

require 'rails_helper'
require 'shared_examples/model_spec_shared_examples' # spec内で使われてるshared_examplesはこのファイル内で定義

RSpec.describe Article, type: :model do
  context '関連付け' do
    context 'dependent' do
      let(:article) { create(:article) }
      let!(:participant) { create_list(:participant, 2, article: article) }

      it 'Articleが削除されたらそれに紐づくParticipantも削除する' do
        expect { article.destroy }.to change(Participant, :count).by(-2)
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
      context '列挙' do
        before do
          article.valid?
          expect(article.errors.messages[:prefecture_code]).to match_array ['is not included in the list']
        end

        context 'nilが与えられた時' do
          let(:article) { build(:article, prefecture_code: nil) }
        end
        context '空文字が与えられた時' do
          let(:article) { build(:article, prefecture_code: '') }
        end
        context '文字列が与えられた時' do
          let(:article) { build(:article, prefecture_code: 'something') }
        end
        context 'リスト（1 ~ 47)以外の数値が与えられた時' do
          let(:article) { build(:article, prefecture_code: 100) }
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
      end
    end

    context '予算' do
      context 'numericality検証' do
        it_behaves_like '整数値以外の時はバリデーションに引っかかること' do
          let(:model_object) { :article }
          let(:field_name) { :budget }
        end
      end
    end
  end
end
