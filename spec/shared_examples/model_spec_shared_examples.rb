# presence系
shared_examples '空文字かnilの時はバリデーションに引っかかること' do
  after do
    @model_object.valid?
    expect(@model_object.errors.messages[field_name]).to include("can't be blank")
  end
  it 'nil' do
    @model_object = build(model_object, field_name => nil)
  end
  it '空文字' do
    @model_object = build(model_object, field_name => '')
  end
end

# length系
shared_examples '値の長さが上限値以下であれば通る' do
  after do
    expect(@model_object.valid?).to eq true
  end
  it '上限値未満であれば通る' do
    @model_object = build(model_object, field_name => 'a' * (max_length - 1))
  end
  it '上限値ちょうどであれば通る' do
    @model_object = build(model_object, field_name => 'a' * max_length)
  end
end
shared_examples '値の長さが上限値を超えていたらバリデーションに引っかかる' do
  after do
    @model_object.valid?
    expect(@model_object.errors.messages[field_name]).to include("is too long (maximum is #{max_length} characters)")
  end
  it '#上限値を超えていれば通らない' do
    @model_object = build(model_object, field_name => 'a' * (max_length + 1))
  end
end

# numericality系
shared_examples '整数値以外の時はバリデーションに引っかかること' do
  after do
    @model_object.valid?
    expect(@model_object.errors.messages[field_name]).to include('is not a number')
  end

  it 'nil' do
    @model_object = build(model_object, field_name => nil)
  end
  it '空文字' do
    @model_object = build(model_object, field_name => '')
  end
  it '文字列' do
    @model_object = build(model_object, field_name => 'something')
  end
end

shared_examples '負の数の時はバリデーションに引っかかること' do
  after do
    @model_object.valid?
    expect(@model_object.errors.messages[field_name]).to include('must be greater than or equal to 0')
  end

  it '-1' do
    @model_object = build(model_object, field_name => -1)
  end
end
