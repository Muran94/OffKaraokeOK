require 'rails_helper'

RSpec.describe MyPageController, type: :controller do
  context 'ログイン中' do
    let(:user) { create(:user) }
    before do
      sign_in user
    end

    describe 'GET #profile' do
      it 'returns http success' do
        get :profile
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #participating_event' do
      it 'returns http success' do
        get :participating_event
        expect(response).to have_http_status(:success)
      end
    end
  end

  context '未ログイン' do
  end
end
