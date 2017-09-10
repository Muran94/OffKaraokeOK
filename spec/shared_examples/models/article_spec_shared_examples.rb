shared_examples '当選者と落選者の人数が正しいこと' do
  it do
    expect(article.participants.where(elected: true).count).to be expected_winner_count
    expect(article.participants.where(elected: false).count).to be expected_rejected_people_count
  end
end
