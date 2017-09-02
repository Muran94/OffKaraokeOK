require 'rails_helper'

RSpec.describe ParticipantsController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  before { sign_in user }

  context 'POST #create' do
    let(:params) { { article_id: article.id } }

    context '正常系' do
      context 'レスポンス' do
        before { post :create, params: params }

        it '投稿詳細ページにリダイレクトされること' do
          expect(response).to redirect_to article
        end
        it 'flash[:notice]の中にメッセージが含まれていること' do
          expect(flash[:notice]).to eq '参加申請が完了しました。'
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
      context '同じユーザー同じ投稿の対するParticipantが既に存在する' do
        before { create(:participant, user: user, article: article) }

        context 'レスポンス' do
          before { post :create, params: params }

          it '投稿詳細ページにリダイレクトされること' do
            expect(response).to redirect_to article
          end
          it 'flash[:alert]の中にメッセージが含まれていること' do
            expect(flash[:alert]).to eq '既に参加済みです。'
          end
        end
      end

      context '不正なデータ' do
        context 'レスポンス' do
          before do
            Participant.any_instance.stub(:save).and_return(false) # save実行時に意図的にfalseを返す
            post :create, params: params
          end

          it '投稿詳細ページにリダイレクトされること' do
            expect(response).to redirect_to article
          end
          it 'flash[:alert]の中にメッセージが含まれていること' do
            expect(flash[:alert]).to eq 'エラーにより参加できませんでした。'
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

        it '投稿詳細ページにリダイレクトされること' do
          expect(response).to redirect_to article
        end
        it 'flash[:notice]の中にメッセージが含まれていること' do
          expect(flash[:notice]).to eq '参加を辞退しました。'
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

          it '投稿詳細ページにリダイレクトされること' do
            expect(response).to redirect_to article
          end
          it 'flash[:alert]の中にメッセージが含まれていること' do
            expect(flash[:alert]).to eq '既に辞退しています。'
          end
        end
      end
    end
  end
end