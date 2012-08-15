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

set :rvm_ruby_string, 'ruby-1.9.3-p125'
set :rvm_install_ruby, :install
set :rvm_install_shell, :zsh

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # Only keep the last 5 releases

before 'deploy:setup', 'rvm:install_ruby'

set :webrick_pid, "#{current_path}/tmp/pids/server.pid"
set :webrick_port, 3001

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path} && rails server -e production -p #{fetch(:webrick_port, 3000)}"
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
