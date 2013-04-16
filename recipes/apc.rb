#
# Cookbook Name:: Extra Configs
# Recipe:: apc
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute

include_recipe "php"

#package "libpcre3-dev"

#php_pear "apc" do
#  directives(:shm_size => "70M")
#  action :install
#end

package "php-apc"
template "#{node['php']['ext_conf_dir']}/apc.ini" do
  source "apc.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:name => "apc", :extensions => ["apc.so"], :directives => {"shm_size" => "256"})
  action action
end
