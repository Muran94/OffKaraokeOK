# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:article) { create(:article) }
    let!(:messages) { create_list(:message, 3, article: article, user_id: user.id) }
    let(:params) { { article_id: article.id } }

    before { get :index, params: params }

    context '基本動作テスト' do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'インスタンス変数の中身が正しいこと' do
        aggregate_failures do
          expect(assigns(:article)).to eq article
          expect(assigns(:messages)).to match_array(messages.to_a)
          expect(assigns(:new_message)).to be_a_new Message
        end
      end
    end

    context '名無しさんテスト' do
      let!(:message) { create_list(:message, 2, article: article, user_id: user.id) }
      let!(:nanashi_no_message) { create(:message, article: article) }

      it '名無しさんのメッセージが混じっていてもリクエストに成功すること' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:article) { create(:article) }

    before { sign_in user }

    context '基本動作テスト' do
      let(:params) do
        {
          article_id: article.id,
          message: {
            text: 'テストメッセージ'
          }
        }
      end

      it 'メッセージの投稿に成功し、レコードが１つ増えること' do
        aggregate_failures do
          expect do
            post :create, params: params
          end.to change(Message, :count).by(1)
          expect(flash[:error]).to eq nil
        end
      end
    end

    context '異常系' do
      context 'バリデーションに引っかかり保存に失敗した場合' do
        let(:params) do
          {
            article_id: article.id,
            message: {
              text: 'a' * (Message::TEXT_MAXIMUM_LENGTH + 1)
            }
          }
        end

        it 'flash[:error]に適切なメッセージが入ること' do
          aggregate_failures do
            expect do
              post :create, params: params
            end.not_to change(Message, :count)
            expect(flash[:error]).to eq 'メッセージの送信に失敗しました'
          end
        end
      end
    end
  end
end
