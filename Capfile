load 'deploy' if respond_to?(:namespace) # cap2 differentiator

load 'config/secure_cap.rb'


# set :domain, "smartbomb.com.au"
set :domain, "208.78.102.127"

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# set :use_sudo, false

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "faces"
set :deploy_to, lambda { "/home/lachie/apps/#{application}" }

set :scm, 'git'
set :repository, 'git://github.com/lachie/roro-faces.git'
set :repository_cache, "git_master"
set :deploy_via, :remote_cache

# Automatically symlink these directories from current/public to shared/public.
set :app_symlinks, %w{mugshots}

set :keep_releases, 3

set :use_sudo, false

task :beta, :roles => :app, :except => { :no_release => true } do
  set :application, "faces-beater"
end


desc "Link up database.yml."
after 'deploy:symlink' do
 cmds = [
   "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml",
   "ln -nfs #{shared_path}/config/gmail.rb #{current_path}/config/gmail.rb",
   "ln -nfs #{shared_path}/config/shared_secret.rb #{current_path}/config/shared_secret.rb",
 
   "rm -rf #{current_path}/public/mugshots",
   "ln -nfs #{shared_path}/public/mugshots #{current_path}/public/mugshots"
 ]
 
 run cmds * ' && '
end

namespace :deploy do  
  task :stop, :roles => :app, :except => { :no_release => true } do
    # nothing: passenger
  end
  task :start, :roles => :app, :except => { :no_release => true } do
    # nothing: passenger
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

task :remove_graphs, :role => :app do
  run "cd #{current_path}/public && rm users/chatter.svg"
  run "cd #{current_path}/public && rm thankyous/beergraph.svg"
end

