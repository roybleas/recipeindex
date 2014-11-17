source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

group :development, :test do
	gem 'sqlite3'
	gem 'guard'
  gem 'rspec-rails'
  gem 'guard-rspec'
  
  gem 'spork-rails'
  # gem 'guard-spork'
  gem 'childprocess'
end

group :test do
	
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner',github: 'bmabey/database_cleaner'
  
  # Uncomment these lines on Windows.
  gem 'rb-notifu', '0.0.4'
  gem 'wdm', '0.1.0'
  
end

group :production do
	gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end
gem 'bootstrap-sass'
gem 'sprockets'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'


gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#in place of debugger trying byebug
gem 'byebug'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]
