require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET #index' do
    context 'レスポンス' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    context 'データ' do
      before do
        create(:article, title: 'カラオケオフ会開催決定！')
        create(:article, title: '今日一緒にカラオケしませんか？')
      end
      it '期待するデータが返ってくるか（タイトル）' do
        get :index
        expect(assigns(:articles).pluck(:title)).to match_array(['カラオケオフ会開催決定！', '今日一緒にカラオケしませんか？'])
      end
      it '期待するデータが返ってくるか（個数）' do
      end
    end
  end
end
