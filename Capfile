load 'deploy'

# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy' # remove this line to skip loading any of the default tasks

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
    upload "config/secrets.yml", "#{current_release}/config/secrets.yml", :via => :scp
    upload "config/database.yml", "#{current_release}/config/database.yml", :via => :scp
  end
end

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

namespace :redis do
  desc "Start the Redis server"
  task :start do
    run "/home/chris/redis-2.4.11/src/redis-server /home/chris/redis-2.4.11/redis.conf"
  end
  
  desc "Stop the Redis server"
  task :stop do
    run 'echo "SHUTDOWN" | nc localhost 6379'
  end
end

namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run "cd #{current_path} && bundle exec thin start -C config/thin.yml"
  end

  desc "Stop the Thin processes"
  task :stop do
    run "cd #{current_path} && bundle exec thin stop -C config/thin.yml"
  end

  desc "Restart the Thin processes"
  task :restart do
    run "cd #{current_path} && bundle exec thin restart -C config/thin.yml"
  end
end

after "deploy", "deploy:cleanup" # Only keep the last 5 releases
before 'deploy:setup', 'rvm:install_ruby'
after 'bundle:install', 'configure:upload_secrets'
after "deploy:start", "memcached:start"
after "deploy:stop", "memcached:stop"
after "deploy:restart", "memcached:restart"
