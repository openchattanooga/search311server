name             "search311server"
maintainer       "Colin Rymer"
maintainer_email "colin.rymer@gmail.com"
license          "UNLICENSE"
description      "Installs/Configures search311server"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends 'java'
depends 'kibana', '0.1.7'
depends 'apache2'
depends 'redis_server'
depends 'logrotate'
