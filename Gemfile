# frozen_string_literal: true

source "https://rubygems.org"

gem "sinatra"

gem "puma"
gem "rackup"

gem "redis"

group :development do
  gem "dotenv"
  gem "rerun"
end

group :test do
  gem "rack-test"
end

group :development, :test do
  gem "rubocop", require: false
end
