source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.3'
gem 'sqlite3' # Use sqlite3 as the database for Active Record
gem 'puma', '~> 3.7' # Use Puma as the app server
gem 'sass-rails', '~> 5.0'
# Materialize
## ドキュメント : http://materializecss.com/
## github : https://github.com/mkhairi/materialize-sass
## サンプル : github : http://materialize.labs.my/
gem 'materialize-sass'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'devise' # 言わずもがな
gem 'annotate', require: false # モデル生成後に自動でドキュメントを生成しコメントを追加してくれる
gem 'haml-rails'
gem 'active_decorator' # デコレーター, github : https://github.com/amatsuda/active_decorator
gem 'jp_prefecture' # 都道府県用Gem, github : https://github.com/chocoby/jp_prefecture

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'capybara', '~> 2.4.3'               # ブラウザでの操作をシミュレートしてテストができる
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.6'              # Rails用機能を追加するRSpecラッハー
  gem 'rails-controller-testing'
  gem 'factory_girl_rails'                 # テストデータの生成
  gem 'faker', '~> 1.4.3'                  # メールアドレス等のデータをランダム生成する
  gem 'spring-commands-rspec', '~> 1.0.2'  # RspecなどでRailsをプリロードする
  gem 'shoulda-matchers'                   # RSpecで使える便利なマッチャー集(ActiveRecord)
end

group :development do
  gem 'web-console', '>= 3.3.0' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors' # 標準のエラー画面よりもわかりやすいエラー画面にするためのGem
  gem 'binding_of_caller'
  gem 'guard-rspec' # ファイルが変更されたらRsepcを自動実行
  gem 'pry-rails' # github : https://github.com/rweng/pry-rails
end

group :test do
  gem 'database_cleaner', '~> 1.3.0' # テスト実行後にDBをクリア
  gem 'simplecov', require: false # テストカバレッジ(テストカバー率)
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
