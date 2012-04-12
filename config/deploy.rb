set :application, "reminderss"
set :repository,  "http://github.com/benchristen/reminderss"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/username/reminderss.com"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git

role :app, "reminderss.com"
role :web, "reminderss.com"
role :db,  "dbserver.com", :primary => true