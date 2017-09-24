module UserDecorator
  def format_sex
    sex ? sex : '未設定'
  end

  def format_birthday
    birthday ? birthday : '未設定'
  end

  def format_introduction
    introduction ? introduction : '未設定'
  end
end
