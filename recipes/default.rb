#
# Cookbook Name:: search311server
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'update apt' do
  command 'apt-get update'
end

package 'build-essential'

node.default['logstash']['inputs'] << {
  :redis => {
    :data_type => 'list',
    :key => node['redis']['key'],
    :type => 'entry'
  }
}

node.default['logstash']['outputs'] << {
  :elasticsearch => {}
}

include_recipe 'search311server::elasticsearch'
include_recipe 'search311server::logstash'
include_recipe 'search311server::kibana'
