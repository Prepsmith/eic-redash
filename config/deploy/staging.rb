set :stage, :staging
set :branch, "develop"

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :server_name, "http://180.150.179.97/"
set :server_ip, '180.150.179.97'
set :server_url, 'http://brass-beijing-ucloud.prepsmith.com'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:application)}"

server 'redash.staging.prepsmith.com', user: 'deployer', roles: %w{web app db}, port: 22

# role :web, %w{iam-api.staging.prepsmith.com}, user: 'deployer'
# role :app, %w{iam-api.staging.prepsmith.com}, user: 'deployer'
# role :db, %w{iam-api.staging.prepsmith.com}, user: 'deployer'

# dont try and infer something as important as environment from
# stage name.
# set :rails_env, :staging

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
# set :unicorn_worker_count, 5

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, true
set :nginx_use_ssl, true