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
after "deploy", "pwd"

before 'deploy:setup', 'rvm:install_ruby'
