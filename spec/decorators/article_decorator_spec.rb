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

  context '#format_participation_cost' do
    let(:article) { build(:article, participation_cost: participation_cost) }
    subject { decorate(article).format_participation_cost }
    context '参加費が存在する場合' do
      let(:participation_cost) { 3000 }
      it '参加費を整形して返すこと' do
        expect(subject).to eq %(#{participation_cost.to_s(:delimited)}円)
      end
    end
    context '参加費が存在しない場合' do
      let(:participation_cost) { nil }
      it '「- 円」が返ること' do
        expect(subject).to eq '- 円'
      end
    end
  end

  context '#participant_count_disp' do
    let!(:article) { create(:article, capacity: 2) }
    subject { decorate(article).participant_count_disp }

    context '参加者が定員以上の場合' do
      context '定員と参加者数がちょうど同じ場合' do
        let!(:participant) { create(:participant, article: article) } # 投稿者1人 + それ以外の参加者1人で合計２人になる
        it '定員以上の時に適用されるタグが返ってくること' do
          expect(subject).to eq %(<strong class="js-participant-num-disp capacity-exceeded">2</strong>)
        end
      end
      context '参加者数が定員を超えていた場合' do
        let!(:participant) { create_list(:participant, 2, article: article) } # 投稿者1人 + それ以外の参加者2人で合計3人になる
        it '定員以上の時に適用されるタグが返ってくること' do
          expect(subject).to eq %(<strong class="js-participant-num-disp capacity-exceeded">3</strong>)
        end
      end
    end
    context '定員割れしている場合' do
      it '定員割れしている時に適用されるタグが返ってくること' do
        expect(subject).to eq %(<strong class="js-participant-num-disp capacity-cracking">1</strong>)
      end
    end
  end

  context '#currently_accepting?' do
    subject { decorate(article).currently_accepting? }
    context '参加締切日を過ぎていない場合（受付中）' do
      let(:article) { build(:article, application_period: 1.day.from_now) }
      it 'trueが返ってくること' do
        expect(subject).to be true
      end
    end
    context '参加締切日を過ぎている場合（受付終了）' do
      let(:article) { build(:article, application_period: 1.day.ago) }
      it 'falseが返ってくること' do
        expect(subject).to be false
      end
    end
  end
end
