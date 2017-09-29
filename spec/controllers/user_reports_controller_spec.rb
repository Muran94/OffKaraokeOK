# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserReportsController, type: :controller do
  describe 'GET #new' do
    let(:user) { create(:user) }
    let(:params) { { id: user.id } }

    before { get :new, params: params }

    context 'リクエスト' do
      it '成功すること' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'インスタンス変数' do
      it 'インスタンス化されたUserReportがnewであること' do
        user_report_instance = assigns(:user_report)
        aggregate_failures do
          expect(user_report_instance).to be_a_new(UserReport)
        end
      end
    end
  end

  context 'POST #create' do
    let(:user) { create(:user) }
    let(:params) do
      {
        user_report: {
          text: '通報しますた',
          user_id: user.id
        }
      }
    end

    context '正常系' do
      context 'リダイレクト' do
        it '該当ユーザーのプロフィールにリダイレクトされること' do
          post :create, params: params
          expect(response).to redirect_to profile_path(user)
        end
      end

      context 'データ' do
        context 'カウント' do
          it 'レコードが１つ増えること' do
            expect do
              post :create, params: params
            end.to change(UserReport, :count).by(1)
          end
        end

        context '中身' do
          it '正しいデータが追加されること' do
            post :create, params: params
            aggregate_failures do
              created_user_report = UserReport.find(assigns(:user_report).id)
              expect(created_user_report.text).to eq '通報しますた'
              expect(created_user_report.user_id).to eq user.id
            end
          end
        end
      end
    end

    context '異常系' do
      let(:params) do
        {
          user_report: {
            text: 'a' * (UserReport::TEXT_MAXIMUM_LENGTH + 1),
            user_id: user.id
          }
        }
      end

      context 'レスポンス' do
        it 'flashの中身が正しく、newテンプレートがレンダリングされること' do
          post :create, params: params
          aggregate_failures do
            expect(flash[:alert]).to eq '通報に失敗しました。'
            expect(response).to render_template :new
          end
        end
      end
    end
  end
end
