require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  context 'ログイン済み' do
    let(:user) { create(:user) }
    before { sign_in user }

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
          get :index
          expect(assigns(:articles).count).to eq 2
        end
      end
    end

    describe 'GET #show' do
      let(:article) {create(:article)}
      let(:params) {{id: article}}
      before do
        get :show, params: params
      end
      context "レスポンス" do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        it 'インスタンス変数に指定IDのArticleを含むこと' do
          expect(assigns[:article]).to eq article
        end
        it 'showテンプレートがrenderされていること' do
          expect(response).to render_template(:show)
        end
      end
    end

    describe 'GET #new' do
      context 'レスポンス' do
        it 'returns http success' do
          get :new
          expect(response).to have_http_status(:success)
        end
        it 'インスタンス変数に空のArticleが含まれていること' do
          get :new
          expect(assigns[:article]).to be_a_new(Article)
        end
        it 'newテンプレートがrenderされていること' do
          get :new
          expect(response).to render_template(:new)
        end
      end
    end
  end

  context '未ログイン' do
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
          get :index
          expect(assigns(:articles).count).to eq 2
        end
      end
    end

    describe 'GET #show' do
      let(:article) {create(:article)}
      let(:params) {{id: article}}
      before do
        get :show, params: params
      end
      context "レスポンス" do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        it 'インスタンス変数に指定IDのArticleを含むこと' do
          expect(assigns[:article]).to eq article
        end
        it 'showテンプレートがrenderされていること' do
          expect(response).to render_template(:show)
        end
      end
    end

    describe 'GET #new' do
      context 'レスポンス' do
        before do
          get :new
        end
        it "returns http success" do
          expect(response).to have_http_status(302)
        end
        it "ログインページにリダイレクトされること" do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
