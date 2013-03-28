#
# Cookbook Name:: Extra Configs
# Recipe:: default
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute
#
# To-Do add attributes to abstract values
  # Known Hosts
  ssh_known_hosts_entry 'github.com'
  ssh_known_hosts_entry 'bitbucket.com'

  if node.php.attribute?("checksum")
    # Requried to install APC.
    package "libpcre3-dev"

    # Install APC.
    php_pear "apc" do
      directives(:shm_size => "70M")
      version "3.1.6" #ARGH!!! debuging enabled on APC builds circa 5/2011. Pin back.
      action :install
    end
    only_if {File.exists?('/etc/php5')}
  end

  if node.apache.attribute?("listen_ports")
    template "/etc/php5/apache2/php.ini" do
      source "php.ini.erb"
      owner "root"
      group "root"
      mode 0644
      notifies(:restart, "service[apache2]", :delayed)
      only_if { File.exists?('/etc/php5/apache2/')}
    end
  end

  # Vimrc
  git "/home/#{ node['extra-configs']['user'] }/.vim" do
    repository "git://github.com/VeggieMeat/Drupal-Git-Vim.git"
    reference "master"
    action :sync
    not_if do
      File.exists?("/home/#{ node['extra-configs']['user'] }/.vimrc")
    end
  end

  link "/home/#{ node['extra-configs']['user'] }/.vim/.vimrc" do
    to "/home/#{ node['extra-configs']['user'] }/.vimrc"
  end

  template "/home/#{ node['extra-configs']['user'] }/.gitconfig" do
    source "gitconfig.erb"
    owner #{ node['extra-configs']['user'] }
    group #{ node['extra-configs']['group'] }
    mode 0644
  end
