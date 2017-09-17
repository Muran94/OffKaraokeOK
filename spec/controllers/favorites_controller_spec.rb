require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  let(:article) { create(:article) }

  context "ログイン済み"

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
              expect(subject['delete_path']).to eq article_favorite_path(article, assigns(:favorite))
              expect(subject['status']).to eq 'created'
            end
          end
        end

        context 'データ' do
          it 'Favoriteが１個増えること' do
            expect do
              post :create, params: params
            end.to change(Favorite, :count).by(1)
          end
        end
      end

      context '異常系' do
        context '既にお気に入り登録済みだった場合' do
          before { create(:favorite, user: user, article: article) }

          context 'レスポンス' do
            before { post :create, params: params }

            it '適切なjsonレスポンスが返ってくること' do
              aggregate_failures do
                expect(subject['delete_path']).to eq article_favorite_path(article, assigns(:favorite))
                expect(subject['status']).to eq 'already_added_to_favorite'
              end
            end
          end
        end

        context '不正なデータ' do
          context 'レスポンス' do
            before do
              Favorite.any_instance.stub(:save).and_return(false) # save実行時に意図的にfalseを返す
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
      let!(:favorite) { create(:favorite, article: article, user: user) }
      let(:params) { { id: favorite.id, article_id: article.id } }

      context '正常系' do
        context 'レスポンス' do
          before { delete :destroy, params: params }

          it '適切なjsonレスポンスが返ってくること' do
            aggregate_failures do
              expect(subject['post_path']).to eq article_favorites_path(favorite.article)
              expect(subject['status']).to eq 'deleted'
            end
          end
        end

        context 'データ' do
          it 'Favoriteが１個減ること' do
            expect do
              delete :destroy, params: params
            end.to change(Favorite, :count).by(-1)
          end
        end
      end

      context '異常系' do
        context '何かしらの理由で既にお気に入り解除されていた場合' do
          context 'レスポンス' do
            before do
              favorite.delete
              delete :destroy, params: params
            end

            it '適切なjsonレスポンスが返ってくること' do
              expect(subject['status']).to eq 'already_deleted'
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
      let!(:participant) { create(:favorite, article: article, user: user) }
      let(:params) { { id: user.id, article_id: article.id } }

      it 'ログインページにリダイレクトされること' do
        delete :destroy, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
