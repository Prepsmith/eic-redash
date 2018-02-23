namespace :pip do
  desc "We install or make sure last pip modulesrequired are all install"
  task :install do
  	on roles(:all) do
      execute "cd  #{release_path}; source ./#{fetch(:virtualenv_path)}/bin/activate;  pip install -r requirements.txt"
    end
  end
end
