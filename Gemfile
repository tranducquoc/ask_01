source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.0.1"
gem "sqlite3"
gem "puma", "~> 3.0"
gem "bootstrap-sass", "~> 3.3.6"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "jquery-rails"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.5"
gem "mysql2"
gem "devise"
gem "simple_form"
gem "carrierwave", "~> 1.0"
gem "ckeditor"
gem "font-awesome-sass"
gem "faker"
gem "bower-rails", "~> 0.11.0"
gem "friendly_id", "~> 5.1.0"
gem "select2-rails"
gem "react-rails"
gem "gon"
gem "i18n-js", ">= 3.0.0.rc11"
gem "config"
gem "will_paginate", "~> 3.1.0"
gem "ransack"

group :development, :test do
  gem "byebug", platform: :mri
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
