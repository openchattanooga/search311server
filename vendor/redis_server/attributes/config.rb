# configuration
default.redis.config.appendonly      = false
default.redis.config.appendfsync     = "everysec"
default.redis.config.daemonize       = true
default.redis.config.databases       = 16
default.redis.config.dbfilename      = "dump.rdb"
default.redis.config.dir             = "/var/lib/redis"
default.redis.config.bind            = "0.0.0.0"
default.redis.config.port            = 6379
default.redis.config.logfile         = "stdout"
default.redis.config.loglevel        = "warning"
default.redis.config.rundir          = "/var/run/redis"
default.redis.config.pidfile         = "redis-server.pid"
default.redis.config.rdbcompression  = true
default.redis.config.timeout         = 300
default.redis.config.save            = ['900 1', '300 10', '60 10000']
default.redis.config.activerehashing = true
