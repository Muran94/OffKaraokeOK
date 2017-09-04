shared_examples '投稿詳細ページにリダイレクトされる' do
  let(:back_url) { root_url }
  before { request.env['HTTP_REFERER'] = back_url }
  it '投稿詳細ページにリダイレクトされること' do
    expect(response).to redirect_to back_url
  end
end
