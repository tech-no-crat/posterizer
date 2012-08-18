redis-server config/redis.conf
memcached -d
sidekiq &
thin start -e development -p 3000
