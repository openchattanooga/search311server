include_recipe "redis_server::install"

bag = node.redis.data_bag_name

node.redis.instances.each do |instance|
  instance_data = data_bag_item( bag, instance )

  redis_server_instance instance do
    instance_data.each do |attribute,value|
      send(attribute, value) unless attribute == "id"
    end
  end
end
