source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '4.2.10'

gem 'rails-api'

gem 'spring', :group => :development

gem 'mysql2', '~> 0.3.18'

# for background work
gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'

gem 'instagram'
gem 'twitter'
gem 'koala' # facebook

# httprb: Better http client than Net::HTTP
gem "http"

# sends you an email when an exception occurs
gem 'exception_notification'

# generates a crontab for our scheduled tasks like doing health checks on delayed_job
gem 'whenever'

group :development, :test do
  gem 'thin'
  gem 'capistrano'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'rvm1-capistrano3', require: false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
