default_run_options[:pty] = true

set :application, "nsarc_call_log"
set :repository,  "git@github.com:bspaulding/north-shore-arc-call-log.git"
set :scm, :git
set :user, "nsarc"
set :use_sudo, false

set :branch, 'master'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/nsarc/#{application}"

role :app, "172.26.23.10"
role :web, "172.26.23.10"
role :db,  "172.26.23.10", :primary => true