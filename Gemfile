source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'


gem 'sass-rails',           '5.0.0.beta1'
gem 'uglifier',             '2.5.3'
gem 'coffee-rails',         '4.0.1'
gem 'jquery-rails'
gem 'turbolinks',           '2.3.0'
gem 'jbuilder',             '2.2.3'
gem 'rails-html-sanitizer', '1.0.1'
gem 'sdoc',                 '0.4.0', group: :doc

group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'rubysl-pty', :platforms => :ruby
	gem 'web-console', :platforms => :ruby
  gem 'spring',      '1.1.3'
  
  # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
	gem 'tzinfo-data', platforms: [:mingw, :mswin]
end


group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
  gem 'unicorn'
end