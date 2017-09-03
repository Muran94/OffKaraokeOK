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

RSpec.describe Article, type: :model do
  context 'バリデーション' do
    context '投稿タイトル' do
      context 'presence検証' do
        it '空の時はバリデーションに引っかかる' do
          article = build(:article, title: nil)
          article.valid?
          expect(article.errors.messages[:title]).to match_array ["can't be blank"]
        end
      end

      context 'length検証' do
        it "#{Article::TITLE_MAXIMUM_LENGTH}字未満であれば通る" do
          article = build(:article, title: 'a' * (Article::TITLE_MAXIMUM_LENGTH - 1))
          expect(article.valid?).to eq true
        end
        it "#{Article::TITLE_MAXIMUM_LENGTH}字ちょうどであれば通る" do
          article = build(:article, title: 'a' * Article::TITLE_MAXIMUM_LENGTH)
          expect(article.valid?).to eq true
        end
        it "#{Article::TITLE_MAXIMUM_LENGTH}字を超えていれば通らない" do
          article = build(:article, title: 'a' * (Article::TITLE_MAXIMUM_LENGTH + 1))
          article.valid?
          expect(article.errors.messages[:title]).to match_array(["is too long (maximum is #{Article::TITLE_MAXIMUM_LENGTH} characters)"])
        end
      end
    end

    context '投稿本文' do
      context 'presence検証' do
        it '空の時はバリデーションに引っかかる' do
          article = build(:article, text: nil)
          article.valid?
          expect(article.errors.messages[:text]).to match_array ["can't be blank"]
        end
      end
      context 'length検証' do
        it "#{Article::TEXT_MAXIMUM_LENGTH}字未満であれば通る" do
          article = build(:article, text: 'a' * (Article::TEXT_MAXIMUM_LENGTH - 1))
          expect(article.valid?).to eq true
        end
        it "#{Article::TEXT_MAXIMUM_LENGTH}字ちょうどであれば通る" do
          article = build(:article, text: 'a' * Article::TEXT_MAXIMUM_LENGTH)
          expect(article.valid?).to eq true
        end
        it "#{Article::TEXT_MAXIMUM_LENGTH}字を超えていれば通らない" do
          article = build(:article, text: 'a' * (Article::TEXT_MAXIMUM_LENGTH + 1))
          article.valid?
          expect(article.errors.messages[:text]).to match_array(["is too long (maximum is #{Article::TEXT_MAXIMUM_LENGTH} characters)"])
        end
      end
    end

    context '会場' do
      context 'presence検証' do
        it '空の時はバリデーションに引っかかる' do
          article = build(:article, venue: nil)
          article.valid?
          expect(article.errors.messages[:venue]).to match_array ["can't be blank"]
        end
      end
      context 'length検証' do
        it "#{Article::VENUE_MAXIMUM_LENGTH}字未満であれば通る" do
          article = build(:article, venue: 'a' * (Article::VENUE_MAXIMUM_LENGTH - 1))
          expect(article.valid?).to eq true
        end
        it "#{Article::VENUE_MAXIMUM_LENGTH}字ちょうどであれば通る" do
          article = build(:article, venue: 'a' * Article::VENUE_MAXIMUM_LENGTH)
          expect(article.valid?).to eq true
        end
        it "#{Article::VENUE_MAXIMUM_LENGTH}字を超えていれば通らない" do
          article = build(:article, venue: 'a' * (Article::VENUE_MAXIMUM_LENGTH + 1))
          article.valid?
          expect(article.errors.messages[:venue]).to match_array(["is too long (maximum is #{Article::VENUE_MAXIMUM_LENGTH} characters)"])
        end
      end
    end

    context '都道府県コード' do
      context '列挙' do
        it 'nilの時はバリデーションに引っかかる' do
          article = build(:article, prefecture_code: nil)
          article.valid?
          expect(article.errors.messages[:prefecture_code]).to match_array ['is not included in the list']
        end
        it '空文字の時はバリデーションに引っかかる' do
          article = build(:article, prefecture_code: '')
          article.valid?
          expect(article.errors.messages[:prefecture_code]).to match_array ['is not included in the list']
        end
        it '文字列の時はバリデーションに引っかかる' do
          article = build(:article, prefecture_code: 'aaaaa')
          article.valid?
          expect(article.errors.messages[:prefecture_code]).to match_array ['is not included in the list']
        end
        it 'リスト（1 ~ 47)以外の数値の時はバリデーションに引っかかる' do
          article = build(:article, prefecture_code: 100)
          article.valid?
          expect(article.errors.messages[:prefecture_code]).to match_array ['is not included in the list']
        end
      end
    end

    context '応募締切日' do
      context 'presence検証' do
        it 'nilの時はバリデーションに引っかかる' do
          article = build(:article, application_period: nil)
          article.valid?
          expect(article.errors.messages[:application_period]).to match_array ["can't be blank"]
        end
        it '空文字の時はバリデーションに引っかかる' do
          article = build(:article, application_period: '')
          article.valid?
          expect(article.errors.messages[:application_period]).to match_array ["can't be blank"]
        end
      end
    end

    context '開催日' do
      context 'presence検証' do
        it 'nilの時はバリデーションに引っかかる' do
          article = build(:article, event_date: nil)
          article.valid?
          expect(article.errors.messages[:event_date]).to match_array ["can't be blank"]
        end
        it '空文字の時はバリデーションに引っかかる' do
          article = build(:article, event_date: '')
          article.valid?
          expect(article.errors.messages[:event_date]).to match_array ["can't be blank"]
        end
      end
    end

    context '定員' do
      context '整数値' do
        it 'nilの時はバリデーションに引っかかる' do
          article = build(:article, capacity: nil)
          article.valid?
          expect(article.errors.messages[:capacity]).to match_array ['is not a number']
        end
        it '数値以外の時はバリデーションに引っかかる' do
          article = build(:article, capacity: 'aaaaa')
          article.valid?
          expect(article.errors.messages[:capacity]).to match_array ['is not a number']
        end
      end
    end

    context '予算' do
      context '整数値' do
        it 'nilの時はバリデーションに引っかかる' do
          article = build(:article, budget: nil)
          article.valid?
          expect(article.errors.messages[:budget]).to match_array ['is not a number']
        end
        it '数値以外の時はバリデーションに引っかかる' do
          article = build(:article, budget: 'aaaaa')
          article.valid?
          expect(article.errors.messages[:budget]).to match_array ['is not a number']
        end
      end
    end
  end
end
