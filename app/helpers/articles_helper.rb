module ArticlesHelper
  def form_submit_button_text
    case action_name
    when 'new'
      '記事を投稿'
    when 'edit'
      '記事を更新'
    end
  end
end
