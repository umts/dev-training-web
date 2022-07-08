# frozen_string_literal: true

# config valid for current version and minor releases of Capistrano
lock '~> 3.17'

set :application, 'dev-training-web'
set :repo_url, 'https://github.com/umts/dev-training-web.git'
set :branch, 'main'

set :app_env, fetch(:stage)
set :default_env, { APP_ENV: fetch(:app_env) }

set :deploy_to, "/srv/#{fetch :application}"

set :keep_releases, 5

append :linked_files, 'config/application.yml'
append :linked_dirs, 'log', 'node_modules', 'public/assets'

before 'git:check', 'git:allow_shared'
before 'deploy:updated', 'yarn:install'

set :log_level, :info

set :capistrano_pending_role, :app
