module ArticleDecorator
  def format_title
    title.present? ? title : "投稿タイトルがありません。"
  end

  def format_text
    text.present? ? text : "投稿本文がありません。"
  end

  def format_venue
    venue.present? ? venue : "-"
  end

  def format_prefecture_name
    if prefecture.present? && prefecture.name.present?
      prefecture.name
    else
      "-"
    end
  end

  def format_event_date
    event_date.present? ? event_date.strftime("%Y年%m月%d日") : "-"
  end

  def format_application_period
    application_period.present? ? application_period.strftime("%Y年%m月%d日") : "-"
  end

  def format_capacity
    capacity.present? ? "#{capacity}人" : "- 人"
  end

  def format_budget
    budget.present? ? "#{budget.to_s(:delimited)}円" : "- 円"
  end
end
