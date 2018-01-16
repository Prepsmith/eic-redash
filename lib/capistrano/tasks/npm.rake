namespace :npm do
  desc "We do install or make sure last pip module required all install"
  task :run do
  	on roles(:all) do
      execute :npm, "run build"
    end
  end
end
