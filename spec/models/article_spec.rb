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
      it '空の時はバリデーションに引っかかる' do
        article = build(:article, title: nil)
        article.valid?
        expect(article.errors.messages[:title]).to match_array ["can't be blank"]
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
        it '1,000字未満であれば通る' do
          article = build(:article, text: 'a' * 999)
          expect(article.valid?).to eq true
        end
        it '1,000字ちょうどであれば通る' do
          article = build(:article, text: 'a' * 1000)
          expect(article.valid?).to eq true
        end
        it '1,000字を超えていれば通る' do
          article = build(:article, text: 'a' * 1001)
          expect(article.valid?).to eq false
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
        it '50時未満であれば通る' do
          article = build(:article, venue: 'a' * 49)
          expect(article.valid?).to eq true
        end
        it '50時ちょうどであれば通る' do
          article = build(:article, venue: 'a' * 50)
          expect(article.valid?).to eq true
        end
        it '50字を超えていれば通らない' do
          article = build(:article, venue: 'a' * 51)
          expect(article.valid?).to eq false
        end
      end
    end
  end
end
