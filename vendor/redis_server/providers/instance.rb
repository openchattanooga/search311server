def load_current_resource
  # Because these attributes are loaded lazily
  # we have to call each one explicitly
  new_resource.vm_swap_file new_resource.vm_swap_file ||"/var/lib/redis/#{new_resource.name}.swap"
  new_resource.pidfile      new_resource.pidfile || "/var/run/redis/#{new_resource.name}.pid"
  new_resource.logfile      new_resource.logfile || "/var/log/redis/#{new_resource.name}.log"
  new_resource.dbfilename   new_resource.dbfilename || "#{new_resource.name}.rdb"
  new_resource.user         new_resource.user  || node.redis.user
  new_resource.group        new_resource.group || node.redis.group


  new_resource.configure_no_appendfsync_on_rewrite
  new_resource.configure_slowlog
  new_resource.configure_list_max_ziplist
  new_resource.configure_maxmemory_samples
  new_resource.configure_set_max_intset_entries
  new_resource.conf_dir


  new_resource.state # Load attributes

  @run_context.include_recipe "runit" if new_resource.init_style == "runit"
end

action :create do
  create_user_and_group
  disable_service
  create_service_script
  create_config
  enable_service
  new_resource.updated_by_last_action(true)
end


action :destroy do
  disable_service
  new_resource.updated_by_last_action(true)
end

private

def create_user_and_group
  group new_resource.group

  user new_resource.user do
    gid new_resource.group
  end
end

def create_config
  directory "#{::File.dirname(new_resource.logfile)}" do
    owner new_resource.user
    group new_resource.group
    mode 00755
    not_if { new_resource.logfile.downcase == "stdout" }
  end

  file new_resource.logfile do
    owner new_resource.user
    group new_resource.group
    mode 00754
    action :create_if_missing
    not_if { new_resource.logfile.downcase == "stdout" }
  end

  directory new_resource.conf_dir do
    owner "root"
    group "root"
    mode 00755
  end

  directory new_resource.dir do
    owner new_resource.user
    group new_resource.group
    mode 00755
  end

  template "#{new_resource.conf_dir}/#{new_resource.name}.conf" do
    source "redis.conf.erb"
    owner "root"
    group "root"
    mode 00644
    variables :config => new_resource.state
  end
end

def create_service_script
  case new_resource.init_style
  when "init"
    template "/etc/init.d/redis-#{new_resource.name}" do
      source "redis_init.erb"
      owner "root"
      group "root"
      mode 00755
      variables new_resource.to_hash
    end
  when "runit"
    runit_service "redis" do
      options({
        :name     => new_resource.name,
        :dst_dir  => new_resource.dst_dir,
        :conf_dir => new_resource.conf_dir,
        :user     => new_resource.user
      })
    end
  end
end

def enable_service
  service redis_service do
    action [ :enable, :start ]
    supports :restart => true
  end
end

def disable_service
  service redis_service do
    action [ :disable, :stop ]
  end
end

def redis_service
  "redis-#{new_resource.name}"
end
