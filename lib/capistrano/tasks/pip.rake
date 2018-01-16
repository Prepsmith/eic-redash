namespace :pip do
  desc "We install or make sure last pip modulesrequired are all install"
  task :install do
  	on roles(:all) do
      within release_path do
        execute "cd #{virtualenv_path} && source ./bin/activate &&  pip install -r requirements.txt"
      end
    end
  end
end
