# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'smcache'

set :repo_url, 'https://github.com/txstate-etc/smcache.git'
# set :branch, 'default'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :user, 'rubyapps'

set :ssh_options, { user: fetch(:user) }

# Set rvm version to the same as we use in development
set :rvm1_ruby_version, "ruby-#{IO.read('Gemfile').match(/^ruby '([^']+)'$/)[1]}@#{IO.read('.ruby-gemset').chomp}"

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :hg

set :passenger_restart_with_touch, true

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

before 'deploy', 'rvm1:install:rvm'
before 'deploy', 'rvm1:install:ruby'
before 'deploy', 'rvm_local:alias:create'

after 'deploy:publishing', 'delayed_job:restart'
after 'deploy:publishing', 'delayed_job:recurring:init'
