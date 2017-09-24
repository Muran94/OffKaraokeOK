require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do

  context "GET #show" do
    let(:user) {create(:user)}
    let(:articles) {create_list(:article, 5, user: user)}
    let(:params) {{user_id: user.id}}

    before { get :show, params: params }

    context "レスポンス" do
      it "リクエストに成功すること" do
        expect(response).to have_http_status(:success)
      end
    end

    context "インスタンス変数" do
      it "正しいデータを取得できていること" do
        aggregate_failures do
          expect(assigns(:user)).to eq user
          expect(assigns(:articles)).to eq articles
        end
      end
    end
  end
end
