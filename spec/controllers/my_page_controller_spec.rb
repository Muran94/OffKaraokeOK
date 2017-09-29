# frozen_string_literal: true
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

    describe 'GET #articles' do
      it 'returns http success' do
        get :articles
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #favorites' do
      it 'returns http success' do
        get :favorites
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #participations' do
      it 'returns http success' do
        get :participations
        expect(response).to have_http_status(:success)
      end
    end
  end

  context '未ログイン' do
  end
end
