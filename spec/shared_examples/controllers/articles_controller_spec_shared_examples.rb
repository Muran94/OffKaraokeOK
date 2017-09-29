# frozen_string_literal: true
shared_examples 'indexアクション正常系' do
  before do
    create(:article, title: 'カラオケオフ会開催決定！')
    create(:article, title: '今日一緒にカラオケしませんか？')
    get :index
  end
  context 'レスポンス' do
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
  context 'データ' do
    it '期待するデータが返ってくるか（タイトル）' do
      expect(assigns(:articles).pluck(:title)).to match_array(['カラオケオフ会開催決定！', '今日一緒にカラオケしませんか？'])
    end
    it '期待するデータが返ってくるか（個数）' do
      expect(assigns(:articles).count).to eq 2
    end
  end
end

shared_examples 'showアクション正常系' do
  let(:article) { create(:article) }
  let(:params) { { id: article } }
  before do
    get :show, params: params
  end
  context 'レスポンス' do
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'インスタンス変数に指定IDのArticleを含むこと' do
      expect(assigns[:article]).to eq article
    end
    it 'showテンプレートがrenderされていること' do
      expect(response).to render_template(:show)
    end
  end
end

shared_examples 'newアクション正常系' do
  before do
    get :new
  end
  context 'レスポンス' do
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'インスタンス変数に空のArticleが含まれていること' do
      expect(assigns[:article]).to be_a_new(Article)
    end
    it 'newテンプレートがrenderされていること' do
      expect(response).to render_template(:new)
    end
  end
end

shared_examples '未ログイン状態ではログインページにリダイレクト' do
  it 'ログインページにリダイレクトされること' do
    expect(response).to redirect_to new_user_session_path
  end
end

shared_examples 'createアクション正常系' do
  let(:params) { { article: attributes_for(:article) } }

  context 'レスポンス' do
    before do
      post :create, params: params
    end
    it 'returns http success' do
      expect(response).to redirect_to article_path(assigns[:article])
    end
    it 'flash[:notice]の中にメッセージが含まれていること' do
      expect(flash[:notice]).to eq '記事を投稿しました。'
    end
  end
  context 'データ' do
    it 'Articleが１個増える' do
      expect do
        post :create, params: params
      end.to change(Article, :count).by(1)
    end
  end
end

shared_examples 'createアクション異常系（バリデーションに引っかかる）' do
  # バリデーションの詳細な動作についてはモデルスペックでテストする。
  # ここではrender・カウントの推移・flashのみ見る
  let(:params) { { article: attributes_for(:article).merge(title: nil) } }

  context 'レスポンス' do
    before do
      post :create, params: params
    end
    it 'newテンプレートをrenderする' do
      expect(response).to render_template :new
    end
    it 'flash[:alert]の中にメッセージが含まれていること' do
      expect(flash[:alert]).to eq '記事の投稿に失敗しました。'
    end
  end
  context 'データ' do
    it 'Articleが１個増える' do
      expect do
        post :create, params: params
      end.not_to change(Article, :count)
    end
  end
end

shared_examples 'editアクション正常系' do
  let(:article) { create(:article, user: user) }
  let(:params) { { id: article } }
  before do
    get :edit, params: params
  end
  context 'レスポンス' do
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'インスタンス変数に空のArticleが含まれていること' do
      expect(assigns[:article]).to eq article
    end
    it 'editテンプレートをrenderすること' do
      expect(response).to render_template :edit
    end
  end
end

shared_examples 'updateアクション正常系' do
  let(:article) { create(:article) }
  let(:params) { { id: article, article: attributes_for(:article, title: 'カラオケオフ会開催！（◯/◯ 更新）') } }
  before do
    patch :update, params: params
  end

  context 'レスポンス' do
    it 'flash[:notice]の中にメッセージが含まれていること' do
      expect(flash[:notice]).to eq '記事を更新しました。'
    end
    it '更新をかけた投稿ページにリダイレクトされること' do
      expect(response).to redirect_to article_path(assigns[:article])
    end
  end
  context 'データ' do
    it 'データが更新される' do
      article.reload
      expect(article.title).to eq 'カラオケオフ会開催！（◯/◯ 更新）'
    end
  end
end

shared_examples 'updateアクション異常系（バリデーションに引っかかる）' do
  # バリデーションの詳細な動作についてはモデルスペックでテストする。
  # ここではrender・カウントの推移・flashのみ見る
  let(:article) { create(:article) }
  let(:params) { { id: article, article: attributes_for(:article).merge(title: nil) } }
  before do
    patch :update, params: params
  end

  context 'レスポンス' do
    it 'editテンプレートをrenderする' do
      expect(response).to render_template :edit
    end
    it 'flash[:alert]の中にメッセージが含まれていること' do
      expect(flash[:alert]).to eq '記事の更新に失敗しました。'
    end
  end
  context 'データ' do
    it 'データの更新に失敗する' do
      article.reload
      expect(article.title).to eq 'カラオケオフ会開催！'
    end
  end
end

shared_examples 'deleteアクション正常系' do
  let!(:article) { create(:article) }
  let(:params) { { id: article } }

  context 'レスポンス' do
    before do
      delete :destroy, params: params
    end
    it 'マイページの投稿一覧ページにリダイレクトされること' do
      expect(response).to redirect_to my_page_articles_path
    end
    it 'flash[:notice]の中にメッセージが含まれていること' do
      expect(flash[:notice]).to eq '記事を削除しました。'
    end
  end
  context 'データ' do
    it 'Articleが１個減ること' do
      expect do
        delete :destroy, params: params
      end.to change(Article, :count).by(-1)
    end
  end
end
