execute 'update apt' do
  command 'apt-get update'
end

include_recipe "logrotate"
include_recipe 'java'
include_recipe "redis_server::server"

group node['logstash']['group'] do
  system true
end

user node['logstash']['user'] do
  group node['logstash']['group']
  home "/var/lib/logstash"
  system true
  action :create
  manage_home true
end

directory node['logstash']['basedir'] do
  action :create
  owner "root"
  group "root"
  mode "0755"
end

# Create directory for logstash
logstash_dir = "#{node['logstash']['basedir']}/server"
directory logstash_dir do
  action :create
  mode "0755"
  owner node['logstash']['user']
  group node['logstash']['group']
end

%w{bin etc lib log tmp }.each do |ldir|
  directory "#{logstash_dir}/#{ldir}" do
    action :create
    mode "0755"
    owner node['logstash']['user']
    group node['logstash']['group']
  end
end

directory "#{logstash_dir}/etc/conf.d" do
  action :create
  mode "0755"
  owner node['logstash']['user']
  group node['logstash']['group']
end

remote_file "#{logstash_dir}/lib/logstash-#{node['logstash']['version']}.jar" do
  owner "root"
  group "root"
  mode "0755"
  source node['logstash']['source_url']
  checksum node['logstash']['checksum']
  action :create_if_missing
end

link "#{logstash_dir}/lib/logstash.jar" do
  to "#{logstash_dir}/lib/logstash-#{node['logstash']['version']}.jar"
  notifies :restart, "service[logstash_server]"
end

if node['logstash']['patterns_dir'] == '/'
  patterns_dir = node['logstash']['patterns_dir']
else
  patterns_dir = "#{logstash_dir}/#{node['logstash']['patterns_dir']}"
end

directory patterns_dir do
  action :create
  mode "0755"
  owner node['logstash']['user']
  group node['logstash']['group']
end

node['logstash']['patterns'].each do |file, hash|
  template_name = patterns_dir + '/' + file
  template template_name do
    source 'patterns.erb'
    owner node['logstash']['user']
    group node['logstash']['group']
    variables(:patterns => hash)
    mode '0644'
    notifies :restart, 'service[logstash_server]'
  end
end

template "#{logstash_dir}/etc/logstash.conf" do
  source 'logstash.conf.erb'
  owner node['logstash']['user']
  group node['logstash']['group']
  mode "0644"
  variables(:patterns_dir => node['logstash']['patterns_dir'])
  notifies :restart, "service[logstash_server]"
  action :create
end

template "/etc/init/logstash_server.conf" do
  mode "0644"
  source "logstash_server.conf.erb"
end

service "logstash_server" do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
  supports :restart => true
end

directory node['logstash']['log_dir'] do
  action :create
  mode "0755"
  owner node['logstash']['user']
  group node['logstash']['group']
  recursive true
end

logrotate_app "logstash_server" do
  path "#{node['logstash']['log_dir']}/*.log"
  frequency "daily"
  rotate "30"
  create "664 #{node['logstash']['user']} #{node['logstash']['group']}"
end
