source 'https://rubygems.org'

gem 'rails', '3.0.20'
gem 'ffi', '1.9.6'

gem "rake"

gem 'taps'
gem 'gravatar_image_tag'
gem 'will_paginate'

group :development do
  gem 'rspec-rails', '2.99.0'
  #gem 'annotate-models'
  gem 'annotate'
end

group :test do
  gem 'autotest'
  gem 'autotest-rails-pure'
  gem 'autotest-growl'
  #BROKEN: gem "ffi"
  gem 'faker'
  gem 'autotest-fsevent'
  gem 'rspec'
  gem 'webrat'
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'test-unit'
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

######################################################################
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
#
# Use unicorn as the web server
# gem 'unicorn'
#
# Deploy with Capistrano
# gem 'capistrano'
#
# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'
#
# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'
#
# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
