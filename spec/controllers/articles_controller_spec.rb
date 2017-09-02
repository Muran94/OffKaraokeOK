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
  end

  context '未ログイン' do
    describe 'GET #index' do
      it_behaves_like 'indexアクション正常系'
    end

    describe 'GET #show' do
      it_behaves_like 'showアクション正常系'
    end

    describe 'GET #new' do
      it_behaves_like 'newアクション異常系（未ログイン時の処理）'
    end
  end
end
