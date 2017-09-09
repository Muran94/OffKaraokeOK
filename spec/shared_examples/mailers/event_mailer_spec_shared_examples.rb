shared_examples '表題・送信元・送信先が全て正しいこと' do
  it do
    aggregate_failures do
      expect(mail).to have_subject target_subject
      expect(mail).to be_delivered_from target_from
      expect(mail).to be_delivered_to targeto_to
    end
  end
end

shared_examples '本文の中身に特定の値が含まれること' do
  it do
    target_contents.each do |target_content|
      expect(mail).to have_body_text target_content
    end
  end
end
