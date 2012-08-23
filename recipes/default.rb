#
# Cookbook Name:: Drupal Extras
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


  package "libpcre3-dev" do
    action :install
  end

  php_pear "memcache" do
    action :install
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
