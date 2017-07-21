#############################################################
#	Application
#############################################################

set :application, "language-translation"
set :deploy_to, "/home/[user_name]/apps/language-translation"
set :whenever_environment, 'production'

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false 
set :scm_verbose, true
set :rails_env, "production" 
set :keep_releases, 3 unless exists?(:keep_releases)

#############################################################
#	Servers
#############################################################

set :user, "[user_name]"
set :domain, "[server_ip_address]"

server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :scm_user,    "systers"
set :branch,      "master"
set :repository,  "git@github.com:systers/language-translation.git"


#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Symlink the upload directories"
  before "deploy:create_symlink" do
    run "mkdir -p #{release_path}/tmp/attachments"
  end
  
  ## Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, roles: :app, except: { no_release: true } do
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :link_db do
    run "ln -s #{shared_path}/fog/aws.yml #{release_path}/config/aws.yml"
    run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
  end

  before "deploy:assets:precompile", "deploy:link_db"
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, roles: :app do ; end
  end
end
