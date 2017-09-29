# frozen_string_literal: true
require 'rails_helper'
require 'shared_examples/controllers/participants_controller_spec_shared_examples' # spec内で使われてるshared_examplesはこのファイル内で定義

RSpec.describe ParticipantsController, type: :controller do
  let!(:article) { create(:article) }

  context 'ログイン済み' do
    let(:user) { create(:user) }
    before { sign_in user }
    subject { JSON.parse(response.body) }

    context 'POST #create' do
      let(:params) { { article_id: article.id } }

      context '正常系' do
        context 'レスポンス' do
          before { post :create, params: params }

          it '適切なjsonレスポンスが返ってくること' do
            aggregate_failures do
              expect(subject['delete_path']).to eq article_participant_path(article, assigns(:participant))
              expect(subject['status']).to eq 'created'
            end
          end
        end

        context 'データ' do
          it 'Participantが１個増えること' do
            expect do
              post :create, params: params
            end.to change(Participant, :count).by(1)
          end
        end
      end

      context '異常系' do
        context '既に参加済みの場合' do
          before { create(:participant, user: user, article: article) }

          context 'レスポンス' do
            before { post :create, params: params }

            it '適切なjsonレスポンスが返ってくること' do
              aggregate_failures do
                expect(subject['delete_path']).to eq article_participant_path(article, assigns(:participant))
                expect(subject['status']).to eq 'already_participated'
              end
            end
          end
        end

        context '不正なデータ' do
          context 'レスポンス' do
            before do
              Participant.any_instance.stub(:save).and_return(false) # save実行時に意図的にfalseを返す
              post :create, params: params
            end

            it '適切なjsonレスポンスが返ってくること' do
              expect(subject['status']).to eq 'unprocessable_entity'
            end
          end
        end
      end
    end

    context 'DELETE #destroy' do
      let!(:participant) { create(:participant, article: article, user: user) }
      let(:params) { { id: participant.id, article_id: article.id } }

      context '正常系' do
        context 'レスポンス' do
          before { delete :destroy, params: params }

          it '適切なjsonレスポンスが返ってくること' do
            aggregate_failures do
              expect(subject['post_path']).to eq article_participants_path(participant.article)
              expect(subject['status']).to eq 'resign_completed'
            end
          end
        end

        context 'データ' do
          it 'Participantが１個減ること' do
            expect do
              delete :destroy, params: params
            end.to change(Participant, :count).by(-1)
          end
        end
      end

      context '異常系' do
        context '何かしらの理由で該当のParticipant既に削除されている場合' do
          context 'レスポンス' do
            before do
              participant.delete
              delete :destroy, params: params
            end

            it '適切なjsonレスポンスが返ってくること' do
              expect(subject['status']).to eq 'already_resigned'
            end
          end
        end
      end
    end
  end

  context '未ログイン状態' do
    context 'POST #create' do
      let(:params) { { article_id: article.id } }

      it 'ログインページにリダイレクトされること' do
        post :create, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'DELETE #destroy' do
      let(:user) { create(:user) }
      let!(:participant) { create(:participant, article: article, user: user) }
      let(:params) { { id: user.id, article_id: article.id } }

      it 'ログインページにリダイレクトされること' do
        delete :destroy, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
