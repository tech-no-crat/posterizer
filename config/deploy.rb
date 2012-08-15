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
set :bundle_flags, "--deployment"
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

  # Do not compile assets unless really required
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end

end
