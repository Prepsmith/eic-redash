namespace :npm do
  desc "We install or make sure last npm modules required are all install"
  task :run do
  	on roles(:all) do
  	  within release_path do
  	  	execute :npm, "install --only=dev"
      	execute :npm, "run build"
      end
    end
  end
end
