# config valid only for current version of Capistrano
lock '3.10.0'

set :application, 'eic-redash'
set :repo_url, 'git@github.com:Prepsmith/eic-redash.git'

set :stages, ['staging', 'production', 'testing']
set :default_stage, 'staging'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

set :deploy_user, "deployer"

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env', 'gunicorn.py')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('node_modules', 'client/dist', 'venv', 'log');

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :nvm_node, 'v7.1.0'
set :nvm_map_bins, %w{node npm yarn forever}

set :virtualenv_path, "venv"

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do

    end
  end
  after :deploy, "pip:install"
  after :deploy, "npm:run"
  after :deploy, "redash:kill_gunicorn"
  after :deploy, "redash:start_redash"
  after :deploy, "redash:start_celery_worker"
  after :deploy, "redash:start_celery_scheduled_worker"
  after :finished, "nginx:reload"
end