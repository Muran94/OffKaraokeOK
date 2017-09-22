require 'rails_helper'
require 'shared_examples/controllers/articles_controller_spec_shared_examples' # spec内で使われてるshared_examplesはこのファイル内で定義

RSpec.describe ArticlesController, type: :controller do
  context 'ログイン済み' do
    let(:user) { create(:user) }
    before { sign_in user }

    describe 'GET #index' do
      it_behaves_like 'indexアクション正常系'
    end

    describe 'GET #show' do
      it_behaves_like 'showアクション正常系'
    end

    describe 'GET #new' do
      it_behaves_like 'newアクション正常系'
    end

    describe 'POST #create' do
      it_behaves_like 'createアクション正常系'
      it_behaves_like 'createアクション異常系（バリデーションに引っかかる）'
    end

    describe 'GET #edit' do
      it_behaves_like 'editアクション正常系'
    end

    describe 'PATCH #update' do
      it_behaves_like 'updateアクション正常系'
      it_behaves_like 'updateアクション異常系（バリデーションに引っかかる）'
    end

    describe 'DELETE #destroy' do
      it_behaves_like 'deleteアクション正常系'
    end
  end

  context '未ログイン' do
    describe 'GET #index' do
      it_behaves_like 'indexアクション正常系'
    end

    describe 'GET #show' do
      it_behaves_like 'showアクション正常系'
    end

    describe 'GET #new' do
      before { get :new }
      it_behaves_like '未ログイン状態ではログインページにリダイレクト'
    end

    describe 'POST #create' do
      let(:article) { create(:article) }
      let(:params) { { article: attributes_for(:article) } }
      before { post :create, params: params }
      it_behaves_like '未ログイン状態ではログインページにリダイレクト'
    end

    describe 'GET #edit' do
      let(:article) { create(:article) }
      let(:params) { { id: article } }
      before { get :edit, params: params }
      it_behaves_like '未ログイン状態ではログインページにリダイレクト'
    end

    describe 'PATCH #update' do
      let(:article) { create(:article) }
      let(:params) { { id: article, article: attributes_for(:article).merge(title: 'カラオケオフ会開催！（◯/◯ 更新）') } }
      before { patch :update, params: params }
      it_behaves_like '未ログイン状態ではログインページにリダイレクト'
    end

    describe 'DELETE #destroy' do
      let(:article) { create(:article) }
      let(:params) { { id: article } }
      before { delete :destroy, params: params }
      it_behaves_like '未ログイン状態ではログインページにリダイレクト'
    end
  end
end
