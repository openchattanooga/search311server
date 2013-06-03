execute 'update apt' do
  command 'apt-get update'
end

package 'curl'

include_recipe 'java'

group node['elasticsearch']['user'] do
  action :create
end

user node['elasticsearch']['user'] do
  comment "ElasticSearch User"
  gid     node['elasticsearch']['user']
  supports :manage_home => false
  action  :create
end

bash "Install Elasticsearch" do
  user 'root'
  cwd '/tmp'
  code <<-EOC
  wget #{node['elasticsearch']['url']} -O elasticsearch.tar.gz
  tar -xf elasticsearch.tar.gz
  rm elasticsearch.tar.gz
  mv elasticsearch-* elasticsearch
  mv elasticsearch /usr/local/share
  EOC
  not_if { File.exists? "/usr/local/share/elasticsearch" }
end

rc_file = "/usr/local/bin/rcelasticsearch"
bash "Create Elasticsearch Service" do
  user 'root'
  cwd '/tmp'
  code <<-EOC
  curl -L #{node['elasticsearch']['servicewrapper']['url']} | tar -xz
  mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/
  rm -Rf *servicewrapper*
  /usr/local/share/elasticsearch/bin/service/elasticsearch install
  ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` #{rc_file}
  EOC
  not_if { File.exists? rc_file }
end
service "elasticsearch" do
  action [:enable, :start]
  supports :status => true, :start => true, :stop => true, :restart => true
end
