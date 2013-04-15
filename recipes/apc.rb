#
# Cookbook Name:: Extra Configs
# Recipe:: apc
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute

include_recipe "postfix"

package "libpcre3-dev"

php_pear "apc" do
  directives(:shm_size => "70M")
  version "3.1.6" #ARGH!!! debuging enabled on APC builds circa 5/2011. Pin back.
  action :install
end
