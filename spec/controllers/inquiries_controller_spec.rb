require 'rails_helper'

RSpec.describe InquiriesController, type: :controller do
  describe 'POST #create' do
    let(:params) do
      {
        inquiry: {
          inquirers_email: 'test@gmail.com',
          type: type,
          message: '質問があります。なぜこのサイトは無料で運営ができるのですか？'
        }
      }
    end
    context '正常系' do
      let(:type) { 1 } # ご質問
      context 'レスポンス' do
        before do
          post :create, params: params
        end
        it 'returns http success' do
          expect(response.status).to eq 200
        end
        it 'response.body.statusの中身が:createdであること' do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['status']).to eq 'created'
        end
      end
      context 'データ' do
        it 'データ保存に成功し、レコードが１つ増えること' do
          expect do
            post :create, params: params
          end.to change(Inquiry, :count).by(1)
        end
      end
    end

    context '異常系' do
      context 'バリデーションに引っかかった場合' do
        let(:type) { 100 } # enumに含まれない値
        before { post :create, params: params }
        context 'レスポンス' do
          it 'returns http success' do
            expect(response.status).to eq 200
          end
          it 'response.body.statusの中身が:unprocessable_entityであること' do
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['status']).to eq 'unprocessable_entity'
          end
        end
      end
    end
  end
end
