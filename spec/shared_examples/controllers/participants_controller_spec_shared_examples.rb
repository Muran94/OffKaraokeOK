shared_examples "投稿詳細ページにリダイレクトされる" do
  it '投稿詳細ページにリダイレクトされること' do
    expect(response).to redirect_to article
  end
end
