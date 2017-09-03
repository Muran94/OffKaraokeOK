shared_examples '空文字かnilの時はバリデーションに引っかかること' do
  after do
    @model_object.valid?
    expect(@model_object.errors.messages[field]).to match_array ["can't be blank"]
  end
  it 'nil' do
    @model_object = build(model_object, field => nil)
  end
  it '空文字' do
    @model_object = build(model_object, field => "")
  end
end
