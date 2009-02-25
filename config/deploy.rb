default_run_options[:pty] = true

set :application, "nsarc_call_log"
set :repository,  "git@github.com:bspaulding/north-shore-arc-call-log.git"
set :scm, :git
set :user, "nsarc"
set :use_sudo, false

set :branch, 'master'

set :deploy_to, "/home/nsarc/#{application}"

role :app, "172.26.23.10"
role :web, "172.26.23.10"
role :db,  "172.26.23.10", :primary => true

# Restart the server the passenger way
namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"