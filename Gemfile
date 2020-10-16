source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.6.5"

gem "aasm"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap4-kaminari-views"
gem "cancancan"
gem "chartkick"
gem "cocoon"
gem "config"
gem "devise"
gem "devise-i18n"
gem "faker"
gem "figaro"
gem "groupdate"
gem "html2slim", "~> 0.2.0"
gem "jbuilder", "~> 2.7"
gem "kaminari"
# gem "mysql2", ">= 0.4.4"
gem "omniauth"
gem "omniauth-facebook"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.3", ">= 6.0.3.3"
gem "rails-i18n"
gem "ransack"
gem "sass-rails", ">= 6"
gem "searchkick"
gem "sidekiq"
gem "simple_form"
gem "slim-rails"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "bullet"
  gem "listen", "~> 3.2"
  gem "mysql2", ">= 0.4.4"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "database_cleaner-active_record"
  gem "rspec-sidekiq"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "simplecov-rcov"
  gem "webdrivers"
end

group :production do
  gem "pg"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
