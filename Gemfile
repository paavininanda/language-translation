source 'https://rubygems.org'
# adding the filtering of the articles
gem 'filterrific'
# generate log file for users
gem 'public_activity'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails' , '4.2.1'
# Use PostgreSQL as the database for Active Record
gem 'pg'
# pg_search builds ActiveRecord named scopes that take advantage of PostgreSQL's full text search
gem 'pg_search'
# Use for uploading files and images.
gem 'carrierwave'
# For validating file upload sizes
gem 'file_validators'
# Use for resizing of images in your rails application
gem 'mini_magick'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# # bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'react-bootstrap-rails'

# add the ember in rails for front-end
gem 'ember-rails'
gem 'ember-source', '~> 1.8.1'
gem 'emblem-rails'

#add the react-rails
gem 'react-rails', '~> 1.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use passenger as the app server
# gem 'passenger'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'activeadmin', '~> 1.0.0.pre1'

gem 'cancancan'
gem 'rolify'
gem 'capybara'
gem 'responders'
# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 3.5.0'
# An invitation strategy for devise
gem 'devise_invitable', '~> 1.5.0'
# Token Authenticatable module of devise.
gem 'devise-token_authenticatable', '~> 0.4.0'

# Provides a way to specify default values for ActiveRecord models
gem 'default_value_for', '~> 3.0.0'
# ActiveModel::Serializer implementation and Rails hooks
gem 'active_model_serializers'
# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for Rails
gem 'kaminari'

group :development do
  gem 'brakeman', :require => false
end

gem 'simple-navigation'
# A lightweight Sass tool set
gem 'bourbon'

gem 'dotenv-rails', :groups => [:development, :test]

group :test do
  gem 'shoulda'
end

group :test, :development do
  # Adds MiniTest as the default testing library in Rails 3 and 4
  gem 'minitest-rails'
  gem 'webrat', require: false
  gem 'mocha', require: false
  gem 'quiet_assets'

  # Show coverage informations directly
  gem 'simplecov', require: false

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'annotate'                              # Annotates Rails/ActiveRecord Models, routes, fixtures based on schema
  gem 'rails-erd'
  gem 'factory_girl_rails'                    # Is a fixtures replacement with a straightforward definition syntax
  gem 'git'

  ## Deploy with Capistrano
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano-ext', '~> 1.2.1'
end

gem 'memory_test_fix'
gem 'rails_12factor', group: :production

ruby '2.2.3'
