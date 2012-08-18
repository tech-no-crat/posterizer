require "bundler/capistrano"
require "rvm/capistrano"
require 'sidekiq/capistrano'

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

#set :webrick_pid, "#{current_path}/tmp/pids/server.pid"
#set :webrick_port, 3001

set :rails_env, :production
set :unicorn_binary, "/usr/bin/unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
