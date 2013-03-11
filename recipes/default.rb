#
# Cookbook Name:: Extra Configs
# Recipe:: default
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute
#
# To-Do add attributes to abstract values

  # Requried to install APC.
  package "libpcre3-dev"

  # Install APC.
  php_pear "apc" do
    directives(:shm_size => "70M")
    version "3.1.6" #ARGH!!! debuging enabled on APC builds circa 5/2011. Pin back.
    action :install
  end

  template "/etc/php5/apache2/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources("service[apache2]"), :delayed
  end

  # Vimrc
  git "/home/vagrant/.vim" do
    repository "git://github.com/VeggieMeat/Drupal-Git-Vim.git"
    reference "master"
    action :sync
    not_if do
      File.exists?("/home/vagrant/.vimrc")
    end
  end

  link "/home/vagrant/.vim/.vimrc" do
    to "/home/vagrant/.vimrc"
  end

  template "/home/vagrant/.gitconfig" do
    source "gitconfig.erb"
    owner "vagrant"
    group "vagrant"
    mode 0644
  end

  # Varnish
  template "/etc/varnish/default.vcl" do
    source "default.vcl.erb"
    mode "0644"
    notifies :restart, resources("service[varnish]"), :delayed
  end
