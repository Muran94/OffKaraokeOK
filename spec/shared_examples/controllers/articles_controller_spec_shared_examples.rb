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

shared_examples 'newアクション異常系（未ログイン時の処理）' do
  context 'レスポンス' do
    before do
      get :new
    end
    it 'returns http success' do
      expect(response).to have_http_status(302)
    end
    it 'ログインページにリダイレクトされること' do
      expect(response).to redirect_to new_user_session_path
    end
  end
end
