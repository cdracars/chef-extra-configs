#
# Cookbook Name:: Drupal Extras
# Recipe:: default
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute
#
# To-Do add attributes to abstract values

  php_pear "pdo" do
    action :install
  end

  # Requried to install APC.
  package "libpcre3-dev"

  # Install APC.
  php_pear "apc" do
    directives(:shm_size => "70M")
    version "3.1.6" #ARGH!!! debuging enabled on APC builds circa 5/2011. Pin back.
    action :install
  end

  php_pear "memcache" do
    action :install
  end

  template "/etc/php5/apache2/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources("service[apache2]"), :delayed
  end

  bash "vimrc-install" do
    code <<-EOH
      cd /home/vagrant
      git clone https://github.com/cdracars/Drupal-Git-Vim.git /home/vagrant/.vim
      ln -s /home/vagrant/.vim/.vimrc /home/vagrant/.vimrc
    EOH
    not_if do
      File.exists?("/home/vagrant/.vimrc")
    end
    ignore_failure true
  end

  execute "git-config-user" do
    command 'git config --global user.name "Cody Dracars"'
  end

  execute "git-config-user-email" do
    command 'git config --global user.email cdracars@gmail.com'
  end

  template "/etc/varnish/default.vcl" do
    source "default.vcl.erb"
    mode "0644"
    notifies :restart, resources("service[varnish]"), :delayed
  end
