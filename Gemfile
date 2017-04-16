def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

source 'https://rubygems.org'
gem 'bundler', '~> 1.10.0'

ruby '2.1.2'

gem 'rails', '4.1.9'

gem 'sass-rails'
gem 'haml-rails'
gem 'bourbon'

gem 'sprockets-rails', '2.1.3'

gem 'bootstrap-sass-extras'
gem 'font-awesome-rails'
gem 'bootstrap-glyphicons'
gem 'autoprefixer-rails'

gem 'devise'
gem 'jwt'

gem 'swagger-docs' # for api help documentation
gem 'swagger-ui_rails'

gem 'acts_as_list'
gem 'uglifier', '>= 1.3.0'
gem 'angular-rails-templates'
gem 'select2-rails'
gem 'fog', '~> 1.20', require: 'fog/aws/storage'
gem 'carrierwave' #needs to load before carrierwave
gem 'pry-rails'
gem 'active_model_serializers', '~> 0.8.0'
gem 'activeresource', require: 'active_resource'
gem 'activeresource-response'
gem 'acts_as_commentable_with_threading'
gem 'mailboxer'
gem 'draper'
gem 'dotenv-rails'
gem 'faraday'
gem 'jbuilder'
gem 'mysql2'
gem 'newrelic_rpm'
gem 'rack-cache'
# gem 'rails-api'
gem 'redis-rack-cache'
gem 'redis-rails'
gem 'redis-namespace'
gem 'sanitize-rails', require: 'sanitize/rails'
gem 'seed-fu'
gem 'sendgrid'
gem 'sidekiq'
gem 'searchkick'
gem 'puma', '~> 2.14.0'
gem 'validates_timeliness'
gem 'rack-cors', '0.2.9',  :require => 'rack/cors'
gem 'whenever'
gem 'airbrake'
gem 'state_machine'
gem 'pundit'
gem 'rolify'
gem 'kaminari'
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'
gem 'high_voltage', '~> 2.2.1'
gem 'zendesk_api'
gem 'carmen'
gem 'paper_trail', '~> 3.0.6'
gem 'geocoder'

group :development do
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pivotal-tracker', require: false
  gem 'spring', '1.1.3'
  gem 'thin'
  gem 'foreman'
  gem 'guard-rubocop'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'web-console', '~> 2.0'
end

group :test, :development, :staging, :beta  do
  gem 'ffaker'
  gem 'factory_girl'
end

group :test do
  gem 'rspec-nc'
  gem 'rspec-rails' #, '~> 3.0.0'
  gem 'spring-commands-rspec'
  gem 'codeclimate-test-reporter', require: nil # Code coverage reporter for CodeClimate/TravisCI
  # gem 'factory_girl'
  gem 'fakeweb'
  gem 'simplecov', require: false
  gem 'webmock'
  gem 'mock_redis', require: false
  gem 'sinatra'
  gem 'shoulda-matchers', '2.7.0', require: false
  gem 'json-schema'
end

group :test, :development do
  gem 'awesome_print'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'minitest'
  gem 'terminal-notifier' # Implicit dependency of rspec-nc gem, explicit dependency of spec/spec_helper.rb
  gem 'timecop'
  gem 'yard'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'teaspoon'
  gem 'guard-teaspoon'
  gem 'phantomjs'
  gem 'pry-byebug'
  gem 'rails-assets-angular-mocks'
end

group :deployment do
  gem 'hipchat', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-sidekiq' , github: 'seuros/capistrano-sidekiq', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-bower', require: false
  gem 'capistrano-eye', require: false
end

source 'https://rails-assets.org' do
  gem 'rails-assets-lodash'
  gem 'rails-assets-angular'
  gem 'rails-assets-angular-cookies'
  gem 'rails-assets-angular-messages'
  gem 'rails-assets-angular-i18n'

  gem 'rails-assets-restangular'
  gem 'rails-assets-angular-ui-router'
  gem 'rails-assets-angular-ui-bootstrap-bower'
  gem 'rails-assets-angular-animate'
  gem 'rails-assets-angular-sanitize'
  gem 'rails-assets-angular-modelizer'
  gem 'rails-assets-textAngular', path: 'vendor/rails-assets-textAngular-1.2.2'
  gem 'rails-assets-angular-ui-select2'
  gem 'rails-assets-danialfarid--angular-file-upload'
  gem 'rails-assets-animate.css'
  gem 'rails-assets-bootstrap-sass-official'
  gem 'rails-assets-bootstrap-additions'
  gem 'rails-assets-angular-motion'
  gem 'rails-assets-angular-strap'
  gem 'rails-assets-angulartics'
  gem 'rails-assets-angular-loading-bar'
  gem 'rails-assets-angular-google-maps'
  gem 'rails-assets-angular-dragdrop-ganarajpr'
  gem 'rails-assets-bootstrap-file-input'
  gem 'rails-assets-angular-breadcrumb'
end
