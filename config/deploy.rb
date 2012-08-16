require "bundler/capistrano"
require "rvm/capistrano"  

server "chrisp.gr", :web, :app, :db, primary: true

set :user, "chris"
set :application, "posterizer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git@github.com:tech-no-crat/posterizer.git"
set :branch, "master"

set :rvm_ruby_string, 'ruby-1.9.3-p125@posterizer'
set :rvm_install_ruby, :install
set :rvm_type, :user

set :bundle_dir, fetch(:shared_path)+"/bundle"
set :bundle_flags, "--deployment --quiet"
set :bundle_without, [:development, :test]

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # Only keep the last 5 releases

before 'deploy:setup', 'rvm:install_ruby'

set :webrick_pid, "#{current_path}/tmp/pids/server.pid"
set :webrick_port, 3001

before "bundle:install", "rvm:trust_rvmrc"

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path} && bundle exec rails server -d -e production -p #{fetch(:webrick_port, 3000)}"
  end

  task :stop, :roles => :app do
    run "#{try_sudo} kill `cat #{webrick_pid}`"
  end

  task :force_stop, :roles => :app do
    run "#{try_sudo} kill -9 `cat #{webrick_pid}`"
  end

  task :restart, :roles => :app do
    stop
    start
  end

end

namespace :configure do
  task :upload_secrets, :roles => :app do
    #puts "HI"
    upload "config/secrets.yml", "#{current_release}/config/secrets.yml", :via => :scp
    upload "config/database.yml", "#{current_release}/config/database.yml", :via => :scp
  end
end

after'bundle:install', 'configure:upload_secrets'

after "deploy:start", "memcached:start"
after "deploy:stop", "memcached:stop"
after "deploy:restart", "memcached:restart"

namespace :memcached do
  desc "Restart the Memcache daemon"
  task :restart, :roles => :app do
    deploy.memcached.stop
    deploy.memcached.start
  end

  desc "Start the Memcache daemon"
  task :start, :roles => :app do
    invoke_command "memcached -P #{current_path}/log/memcached.pid  -d", :via => run_method
  end

  desc "Stop the Memcache daemon"
  task :stop, :roles => :app do
    pid_file = "#{current_path}/log/memcached.pid"
    invoke_command("killall -9 memcached", :via => run_method) if File.exist?(pid_file)
  end
end
