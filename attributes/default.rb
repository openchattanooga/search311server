default['elasticsearch']['user'] = 'elasticsearch'
default['elasticsearch']['url'] = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.tar.gz"
default['elasticsearch']['servicewrapper']['url'] = "http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master"

default['redis']['host'] = 'localhost'
default['redis']['port'] = '6379'
default['redis']['list'] = 'logstash'
default['redis']['key']  = 'entries'

default['logstash']['user'] = 'logstash'
default['logstash']['group'] = 'logstash'
default['logstash']['basedir'] = '/opt/logstash'
default['logstash']['patterns_dir'] = 'etc/patterns'
default['logstash']['log_dir'] = '/var/log/logstash'
default['logstash']['pid_dir'] = '/var/run/logstash'

default['logstash']['version'] = '1.1.9'
default['logstash']['source_url'] = 'https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar'
default['logstash']['checksum'] = 'e444e89a90583a75c2d6539e5222e2803621baa0ae94cb77dbbcebacdc0c3fc7'
default['logstash']['zeromq_packages'] = [ "zeromq",  "libzmq-dev"]
default['logstash']['xms'] = '1024M'
default['logstash']['xmx'] = '1024M'
default['logstash']['java_opts'] = ''
default['logstash']['gc_opts'] = '-XX:+UseParallelOldGC'
default['logstash']['ipv4_only'] = false
default['logstash']['debug'] = false
default['logstash']['home'] = '/opt/logstash/server'
default['logstash']['install_rabbitmq'] = false
default['logstash']['install_zeromq'] = true

default['logstash']['tcp_port'] = 5959
default['logstash']['patterns'] = []
default['logstash']['inputs'] = []
default['logstash']['filters'] = []
default['logstash']['outputs'] = []
