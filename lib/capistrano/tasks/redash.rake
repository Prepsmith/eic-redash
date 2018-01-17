namespace :redash do
  # This task is meants to be run only one time
  desc "We create redash DB"
  task :create_db do
  	on roles(:all) do
      within release_path do
        execute "source #{virtualenv_path}/bin/activate && source .env && bin/run ./manage.py database create_tables"
      end
    end
  end

  desc "Start celery worker"
  task :start_celery_worker do
  	on roles(:all) do
      within release_path do
        execute "source #{virtualenv_path}/bin/activate && source .env && daemon --pidfile=#{deploy_to}/celery-queries.pid -- ./venv/bin/celeryd worker --workdir=#{release_path} --app=redash.worker --beat -c2 -Qqueries,celery --maxtasksperchild=10 -Ofair"
      end
    end
  end

  desc "Start celery scheduled worker"
  task :start_celery_scheduled_worker do
  	on roles(:all) do
      within release_path do
        execute "source #{virtualenv_path}/bin/activate && source .env && daemon --pidfile=#{deploy_to}/celery-scheduled-queries.pid -- #{virtualenv_path}/bin/celery worker --workdir=#{release_path} --app=redash.worker -c2 -Qscheduled_queries --maxtasksperchild=10 -Ofair"
      end
    end
  end

  desc "Start redash"
  task :start_redash do
  	on roles(:all) do
      within release_path do
        execute "source #{virtualenv_path}/bin/activate && source .env && #{virtualenv_path}/bin/gunicorn", "redash.wsgi:app", '-c=gunicorn_config.py', "--pid=#{pid_file}"
      end
    end
  end
end
