module ArticleDecorator
  WD = %w(日 月 火 水 木 金 土).freeze

  def format_title
    title.present? ? title : '投稿タイトルがありません。'
  end

  def format_text
    text.present? ? text : '投稿本文がありません。'
  end

  def format_venue
    venue.present? ? venue : '-'
  end

  def format_prefecture_name
    if prefecture.present? && prefecture.name.present?
      prefecture.name
    else
      '-'
    end
  end

  def format_event_date
    event_date.present? ? event_date.strftime("%Y年%m月%d日（#{WD[event_date.wday]}）") : '-'
  end

  def format_application_period
    application_period.present? ? %(#{application_period.strftime("%Y年%m月%d日（#{WD[application_period.wday]}）")} まで) : '-'
  end

  def format_capacity
    capacity.present? ? "#{capacity}人" : '- 人'
  end

  def format_participation_cost
    participation_cost.present? ? "#{participation_cost.to_s(:delimited)}円" : '- 円'
  end

  def participant_count_disp
    if participants.count >= capacity
      content_tag :strong, participants.count, class: 'js-participant-num-disp capacity-exceeded'
    else
      content_tag :strong, participants.count, class: 'js-participant-num-disp capacity-cracking'
    end
  end

  # まだ受付中か判定
  def currently_accepting?
    application_period > Time.zone.now ? true : false
  end
end
