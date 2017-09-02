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
  end
end
