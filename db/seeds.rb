# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

begin
  user = User.create(nickname: '名無し', email: 'nanashi@gmail.com', password: 'nanashi')

  Article.skip_callback(:create, :after, :_draw_lots)
  300.times do |num|
    article = Article.create(
        title: "カラオケオフ会！#{num}",
        text: 'やりますよ！',
        application_period: Time.zone.now,
        event_date: 1.day.from_now,
        capacity: (1..5).to_a.sample,
        venue: "カラオケ館hogehoge#{num}号店",
        budget: (1000..3000).to_a.sample,
        prefecture_code: 1,
        user: user
      )
    if article.save
      puts "success!!!"
    else
      puts article.errors.messages
    end
  end
  Article.set_callback(:create, :after, :_draw_lots)
rescue => e
  puts e.message
end
