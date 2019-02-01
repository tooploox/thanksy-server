# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.0"

gem "bootsnap", ">= 1.1.0", require: false
gem "rack-cors"
gem "faraday"
gem "pg"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.2"
gem "slack-ruby-client"
gem "sucker_punch"

group :development, :test do
  gem "dotenv-rails"
  gem "pry"
  gem "rubocop", require: false
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner"
  gem "rspec-rails"
  gem "timecop"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
