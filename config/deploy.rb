default_run_options[:pty] = true

set :application, "nsarc_call_log"
set :repository,  "git@github.com:bspaulding/north-shore-arc-call-log.git"
set :scm, :git
set :user, "nsarc"
set :use_sudo, false

set :branch, 'master'

set :deploy_to, "/home/nsarc/#{application}"
set :deploy_via, :copy

role :app, "192.168.10.13"
role :web, "192.168.10.13"
role :db,  "192.168.10.13", :primary => true

# Restart the server the passenger way
namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"

after 'deploy:update_code', 'deploy:link_profile_images' 
namespace(:deploy) do 
	task :link_profile_images do 
		run "cd #{release_path} && ln -nfs #{shared_path}/person #{release_path}/public/person"
	end 
end 