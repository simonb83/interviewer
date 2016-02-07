source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json', '1.7.7'

gem 'sqlite3'
gem 'mysql2'
gem 'devise'
gem 'cancan'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'compass-h5bp'
end

group :test do
  gem 'shoulda'
  gem 'mocha', require: false
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'simplecov', :require => false
end

group :development, :test do
  gem 'factory_girl_rails'
  gem "rspec-rails", "~> 2.0"
  gem "query_reviewer", :git => "git://github.com/nesquena/query_reviewer.git"
end

gem 'jquery-rails', '2.1.2'
gem 'html5-rails'

gem 'whenever', :require => false

#Twilio Gem for access to API
gem 'twilio-ruby'

#High Voltage for Static Pages
gem 'high_voltage'

#Brakeman for security testing
gem 'brakeman'

#Griddler for receiving email
gem 'griddler', git: "https://github.com/thoughtbot/griddler.git", ref: '46bbd1bd5b87a002e7e06442d0dd8b1adc0b6c17'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem "rack-bridge", :group => :development
