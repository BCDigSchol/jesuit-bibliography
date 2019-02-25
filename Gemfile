source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.7', '>= 3.7.1'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'sunspot_solr'
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'blacklight', '>= 6.1'
group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end

gem 'rsolr', '>= 1.0', '< 3'
gem 'jquery-rails'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'blacklight-marc', :git => 'https://github.com/BCDigSchol/blacklight-marc.git', :tag => 'backport-traject'

# make sure we're using most recent version of loofah
# see CVE-2018-16468
gem "loofah", ">= 2.2.3"

# make sure we're using the most recent version of bootstrap-sass
# see CVE-2019-8331 
gem "bootstrap-sass", ">= 3.4.1"

# Jesuit Bibliography Staff gems
gem 'pg'
gem 'rails_admin', '~> 1.3'
gem 'simple_form'
gem 'nested_form_fields'
gem 'cocoon'
gem 'cancancan'
gem 'csv'
gem 'sunspot_rails'
gem 'progress_bar'
gem 'kaminari'
gem "wice_grid"
gem 'font-awesome-sass',  '~> 4.3'
gem 'bootstrap-datepicker-rails'
gem 'select2-rails'
gem 'alphabetical_paginate', :git => 'https://github.com/BCDigSchol/alphabetical_paginate'
gem 'tinymce-rails'
gem 'blacklight_advanced_search'
gem 'blacklight_range_limit'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'bibtex-ruby'
gem 'citeproc-ruby'
gem 'csl-styles'
gem 'parsley-rails'