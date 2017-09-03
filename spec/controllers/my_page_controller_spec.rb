require 'rails_helper'

RSpec.describe MyPageController, type: :controller do

  describe "GET #profile" do
    it "returns http success" do
      get :profile
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #participating_event" do
    it "returns http success" do
      get :participating_event
      expect(response).to have_http_status(:success)
    end
  end

end
