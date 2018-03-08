namespace :redash do
  # This task is meants to be run only one time
  desc "We create redash DB"
  task :create_db do
  	on roles(:all) do
      execute "cd #{release_path}; source ./#{fetch(:virtualenv_path)}/bin/activate; source .env; bin/run ./manage.py database create_tables"
    end
  end

  desc "Kill existing gunicorn process for redash"
  task :kill_gunicorn do
    on roles(:all) do
      puts "kill -9 `ps aux |grep #{fetch(:application)}_#{fetch(:stage)} | awk '{ print $2 }'`"
      execute "kill -9 `ps aux |grep #{fetch(:application)}_#{fetch(:stage)}| awk '{ print $2 }'`"
    end
  end

  desc "Kill existing celery process for redash"
  task :kill_celery do
    on roles(:all) do
      puts "kill -9 `ps aux |grep celery|grep redash | awk '{ print $2 }'`"
      execute "kill -9 `ps aux |grep celery|grep redash | awk '{ print $2 }'`"
    end
  end

  desc "restart supervisor"
  task :restart_supervisor do
    on roles(:all) do
      execute "sudo service supervisor restart"
    end
  end

  desc "Start redash"
  task :start_redash do
  	on roles(:all) do
      execute "cd #{release_path}; source ./#{fetch(:virtualenv_path)}/bin/activate; source .env; #{fetch(:virtualenv_path)}/bin/gunicorn redash.wsgi:app -c=gunicorn.py --pid=gunicorn.pid --name=#{fetch(:application)}_#{fetch(:stage)} --limit-request-line 0"
    end
  end
end
