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
  ssh_known_hosts_entry 'bitbucket.org'

  # Requried to install APC.
  package "libpcre3-dev"

  # Install APC.
  php_pear "apc" do
    directives(:shm_size => "70M")
    version "3.1.6" #ARGH!!! debuging enabled on APC builds circa 5/2011. Pin back.
    action :install
    only_if do
      File.exists?("/etc/php5")
    end
  end

  # Vimrc
  git "git vimrc clone" do
    repository "git://github.com/VeggieMeat/Drupal-Git-Vim.git"
    reference "master"
    action :sync
    destination "/etc/vim/.vim"
    not_if do
      File.exists?("/etc/vim/.vim")
    end
  end

  link "/etc/vim/.vim/.vimrc" do
    to "/etc/vim/vimrc.local"
  end

  template File.expand_path("~/.gitconfig") do
    source "gitconfig.erb"
    owner #{ node['extra-configs']['user'] }
    group #{ node['extra-configs']['group'] }
    mode 0644
  end
