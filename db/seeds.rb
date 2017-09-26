# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

title_samples = %w(
  8/18（日）カラオケオフ会開催決定！洋楽祭り！
  ノージャンルお祭り！今週の日曜日はカラオケオフ会にお越しください！
  TheBeatles縛り！ビールでも飲みながら楽しく歌いましょう！
  平均250名参加！馬鹿騒ぎしながら歌えるのはここだけ！
  ボカロだけ。新宿hogehoge店
  今から新宿カラ館で歌える人募集！
)

text_samples = %w(
  私は今日いやいやその相違性という方のところにいうたなかっ。いよいよ今で供家はすなわちその保留たですでもに好まているだにも授業もたらすでしだから、どうにもしですんなけれます。
  主義を上げよまいつもりももし以前でよしなけれましな。いったい大森さんを誘惑国こう教育の怠けない主義その会あなたか講義をとかいうお合点んですなうて、その当時は俺か一つご免を用いよて、木下君のので人のここをとやかくご立脚とよして私陰にご馳走で断っようにいくらご学習をあろですたて、どうにかとうてい滅亡に云わませてならなら事に云っだう。
  しかしたとえばご機械がなるのは始終変則とできるありて、この義務では潰さなからという自分が落ちてならました。そのため兵隊のうちこの中は私中に申し上げだっかと嘉納君に掘りたた、根本の毎日ますにおいてご教育んずませて、らの時にずるに当時などの力で毎日いと出しから、だんだんの生涯に引けるてそのところがどうぞ向いたないとあるですのますば、なしなたてもう少しごはめ出ですのですならう。だから借着か厄介か独立をおっしゃれずと、絶対上力にやるて得ないうちへ実始末の直接をすむですない。
  昨日でもいくら知れて見たならましでが、まずちょうどして約束は始終よそよそしいなけれはずです。もっとも実講演が放っがは来るましものうて、貧民にも、いかにそこか立ち入りからふらしられうない換えるられまいなと至るが、防もするているですます。
  とうとうもうはすでに個人という来なて、どこをは場合中などあなたのご運動はなし来もらいたない。それはもちろん使用ののにご学習は見合せているなけれあるですたて、二十の世の中へそうするんという意味なから、だからどういう例外の自力にしれるて、あなたかのそれの鉱脈に抑圧が至るているでしょのたあると反抗しから解いうならましべき。
  考のつまり嘉納君からまた少々作っですのたんた。ネルソンさんもある程度女に帰ってしですのたたな。（ただ他人をする時ないますざるからますは縛りつけでうて、）あまり読まらしい書物に、朝日新聞の道具までするて見えという、亡骸の忠告は一生の限りばかりあっなりものが這入りませから自白士傾けるがいたに対してお尻な事ます。
  それはやはり人より教えでように気がついたって来ますのですけれどももしくはそう驚招き考えたた。それでさっそく一日は哲学を考えて、一生をいよいよ広めようたと畳んが、ないたたからあるいは実学習であるなくっな。
  政府の今を、この自力の将来に懸だけ、一部中になぜ今三五一人にできるまでのその道を、それか知れです見当に見えるた場合はもっともしがるのでしょので、もうどうこの世からないて、どういう事からすま訳が失礼なけれ小さい過ぎでだ。または単に事実一三四字を変っかもも並べべきという自由べき謝罪に怒りて、がたをその上そんなために帰っているう事た。
)

begin
  User.delete_all
  user = User.create(nickname: 'PaulMcCartney', email: 'paulmccartney@gmail.com', password: 'nanashi')

  Article.delete_all
  Article.skip_callback(:create, :after, :_draw_lots)
  500.times do |num|
    article = Article.create(
      title: title_samples.sample,
      text: text_samples.sample,
      application_period: Time.zone.now,
      event_date: Random.rand(Time.zone.now..2.month.from_now),
      capacity: (2..5).to_a.sample,
      venue: "カラオケ館hogehoge#{num}号店",
      participation_cost: (1000..3000).to_a.sample,
      prefecture_code: (1..47).to_a.sample,
      user: user
    )
    if article.save
      puts 'success!!!'
    else
      puts article.errors.messages
    end
  end
  Article.set_callback(:create, :after, :_draw_lots)
rescue => e
  puts e.message
end
