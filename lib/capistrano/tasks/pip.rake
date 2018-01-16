namespace :pip do
  desc "We do install or make sure last pip module required all install"
  task :install do
  	on roles(:all) do
      execute "cd #{current_path} && sudo pip install -r requirements.txt"
    end
  end
end
