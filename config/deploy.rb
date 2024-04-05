# config valid for current version and patch releases of Capistrano
lock "~> 3.18.1"

set :application, 'contact'
set :repo_url, 'git@github.com:Raushan998/Contact.git'
set :branch, :main
set :deploy_to, '/home/deploy/contact'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-3.3.0'

set :puma_service_unit_name, 'contact_puma_production.service'
set :puma_cmd, "#{fetch(:rvm_bin_path)}/rvm ruby-3.3.0 do bundle exec puma -C #{shared_path}/puma.rb"

namespace :puma do
  desc 'Start Puma'
  task :start do
    on roles(:app) do
      within release_path do
        invoke 'systemctl:start_puma'
      end
    end
  end

  desc 'Stop Puma'
  task :stop do
    on roles(:app) do
      within release_path do
        invoke 'systemctl:stop_puma'
      end
    end
  end

  desc 'Restart Puma'
  task :restart do
    on roles(:app) do
      within release_path do
        invoke 'systemctl:restart_puma'
      end
    end
  end
end

namespace :systemctl do
  task :start_puma do
    execute :sudo, '/bin/systemctl', :start, fetch(:puma_service_unit_name)
  end

  task :stop_puma do
    execute :sudo, '/bin/systemctl', :stop, fetch(:puma_service_unit_name)
  end

  task :restart_puma do
    execute :sudo, '/bin/systemctl', :restart, fetch(:puma_service_unit_name)
  end
end

after 'deploy:publishing', 'puma:restart'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
