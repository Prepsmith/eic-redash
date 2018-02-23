namespace :redash do
  # This task is meants to be run only one time
  desc "We create redash DB"
  task :create_db do
  	on roles(:all) do
      execute "cd #{release_path}; source ./#{fetch(:virtualenv_path)}/bin/activate; source .env; bin/run ./manage.py database create_tables"
    end
  end

  desc "Start celery worker"
  task :start_celery_worker do
  	on roles(:all) do
      execute "cd #{release_path}; source ./#{fetch(:virtualenv_path)}/bin/activate; source .env; daemon --pidfile=#{deploy_to}/celery-queries.pid -- /#{fetch(:virtualenv_path)}/bin/celeryd worker --workdir=#{release_path} --app=redash.worker --beat -c2 -Qqueries,celery --maxtasksperchild=10 -Ofair"
    end
  end

  desc "Start celery scheduled worker"
  task :start_celery_scheduled_worker do
  	on roles(:all) do
      execute "cd #{release_path}; source ./#{fetch(:virtualenv_path)}/bin/activate; source .env; daemon --pidfile=#{deploy_to}/celery-scheduled-queries.pid -- ./#{fetch(:virtualenv_path)}/bin/celery worker --workdir=#{release_path} --app=redash.worker -c2 -Qscheduled_queries --maxtasksperchild=10 -Ofair"
    end
  end

  desc "Kill existing gunicorn process for redash"
  task :kill_gunicorn do
    on roles(:all) do
      execute "kill -9 `ps aux |grep #{fetch(:application)}_#{fetch(:stage)} |grep redash | awk '{ print $2 }'`"
    end
  end

  desc "Start redash"
  task :start_redash do
  	on roles(:all) do
      execute "cd #{release_path}; source ./#{fetch(:virtualenv_path)}/bin/activate; source .env; #{fetch(:virtualenv_path)}/bin/gunicorn redash.wsgi:app -c=gunicorn.py --pid=gunicorn.pid --name=#{fetch(:application)}_#{fetch(:stage)}"
    end
  end
end
