# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.6.0"

gem "pg"
gem "puma"
gem "rack-indifferent"
gem "rake"
gem "roda"
gem "sequel"

group :development do
  gem "shotgun"
end

group :development, :test do
  gem "dotenv"
  gem "pry"
  gem "rubocop", require: false
end

group :test do
  gem "rack-test"
  gem "rspec"
end
