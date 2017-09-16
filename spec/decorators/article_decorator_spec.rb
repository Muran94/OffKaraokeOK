require 'rails_helper'

describe ArticleDecorator do
  context '#format_title' do
    let(:article) { build(:article, title: title) }
    subject { decorate(article).format_title }
    context '投稿タイトルが存在する場合' do
      let(:title) { 'カラオケオフ会開催！' }
      it 'そのまま投稿タイトルを返すこと' do
        expect(subject).to eq article.title
      end
    end
    context '投稿タイトルが存在しない場合' do
      let(:title) { nil }
      it '「投稿タイトルがありません。」が返ること' do
        expect(subject).to eq '投稿タイトルがありません。'
      end
    end
  end

  context '#format_text' do
    let(:article) { build(:article, text: text) }
    subject { decorate(article).format_text }
    context '投稿本文が存在する場合' do
      let(:text) { '来週の日曜のお昼頃からカラオケオフ会を開催します！詳細はこちら！' }
      it 'そのまま投稿本文を返すこと' do
        expect(subject).to eq article.text
      end
    end
    context '投稿本文が存在しない場合' do
      let(:text) { nil }
      it '「投稿本文がありません。」が返ること' do
        expect(subject).to eq '投稿本文がありません。'
      end
    end
  end

  context '#format_venue' do
    let(:article) { build(:article, venue: venue) }
    subject { decorate(article).format_venue }
    context '会場が存在する場合' do
      let(:venue) { '新宿カラオケ館hogehoge店' }
      it 'そのまま会場を返すこと' do
        expect(subject).to eq article.venue
      end
    end
    context '会場が存在しない場合' do
      let(:venue) { nil }
      it '「-」が返ること' do
        expect(subject).to eq '-'
      end
    end
  end

  context '#format_prefecture_name' do
    let(:article) { build(:article, prefecture_code: prefecture_code) }
    subject { decorate(article).format_prefecture_name }
    context '都道府県コードが存在する場合' do
      let(:prefecture_code) { 13 } # 東京都
      it '都道府県名を返すこと' do
        expect(subject).to eq article.prefecture.name
      end
    end
    context '都道府県コードが存在しない場合' do
      let(:prefecture_code) { nil }
      it '「-」が返ること' do
        expect(subject).to eq '-'
      end
    end
  end

  context '#format_event_date' do
    let(:article) { build(:article, event_date: event_date) }
    subject { decorate(article).format_event_date }
    context '開催日が存在する場合' do
      let(:event_date) { Date.new(1970, 1, 1) }
      it '開催日を整形して返すこと' do
        expect(subject).to eq article.event_date.strftime("%Y年%m月%d日（#{ArticleDecorator::WD[event_date.wday]}）")
      end
    end
    context '開催日が存在しない場合' do
      let(:event_date) { nil }
      it '「-」が返ること' do
        expect(subject).to eq '-'
      end
    end
  end

  context '#format_application_period' do
    let(:article) { build(:article, application_period: application_period) }
    subject { decorate(article).format_application_period }
    context '応募締切日が存在する場合' do
      let(:application_period) { 2.days.from_now }
      it '応募締切日を整形して返すこと' do
        expect(subject).to eq %(#{application_period.strftime("%Y年%m月%d日（#{ArticleDecorator::WD[application_period.wday]}）")} まで)
      end
    end
    context '応募締切日が存在しない場合' do
      let(:application_period) { nil }
      it '「-」が返ること' do
        expect(subject).to eq '-'
      end
    end
  end

  context '#format_capacity' do
    let(:article) { build(:article, capacity: capacity) }
    subject { decorate(article).format_capacity }
    context '定員が存在する場合' do
      let(:capacity) { 15 }
      it '定員を整形して返すこと' do
        expect(subject).to eq %(#{article.capacity}人)
      end
    end
    context '定員が存在しない場合' do
      let(:capacity) { nil }
      it '「- 人」が返ること' do
        expect(subject).to eq '- 人'
      end
    end
  end

  context '#format_budget' do
    let(:article) { build(:article, budget: budget) }
    subject { decorate(article).format_budget }
    context '予算が存在する場合' do
      let(:budget) { 3000 }
      it '予算を整形して返すこと' do
        expect(subject).to eq %(#{budget.to_s(:delimited)}円)
      end
    end
    context '予算が存在しない場合' do
      let(:budget) { nil }
      it '「- 円」が返ること' do
        expect(subject).to eq '- 円'
      end
    end
  end
end
