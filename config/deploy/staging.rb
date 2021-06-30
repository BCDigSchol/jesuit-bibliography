# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

#server '192.168.33.55', roles: [:web, :app, :db], primary: true
server 'staging.job.lontracanadensis.net', roles: [:web, :app, :db], primary: true

set :repo_url, 'git@github.com:BCDigSchol/jesuit-bibliography.git'
set :application, 'bc-jesuit-bibliography'
set :user, 'blacklight'
set :branch, 'staging'
set :stage, :staging

set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :ssh_options, {forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa)}
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false # Change to true if using ActiveRecord

append :linked_files, 'config/master.key'

# can be invoked like `cap staging deploy:rake task=db:seed`
# https://capistranorb.com/documentation/tasks/rails/
namespace :deploy do
    desc 'Runs any rake task, cap staging deploy:rake task=db:seed'
    task rake: [:set_rails_env] do
      on release_roles([:db]) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, ENV['task']
          end
        end
      end
    end

    # cleans out database and reimports default content
    # can be invoked like `cap staging deploy:db:reset`
    namespace :db do
        desc 'clean, rebuild, and reimport database'
        task :reset do
            on roles(:db) do
                within "#{current_path}" do
                    execute :rake, 'db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1'
                    execute :rake, 'db:seed'
                    execute :rake, 'import:all'
                    execute :rake, 'importdata:all_noninteractive'
                end
            end
        end
    end
end

namespace :debug do
    desc 'Print ENV variables'
    task :env do
      on roles(:app), in: :sequence, wait: 5 do
        execute :printenv
      end
    end
end


# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }