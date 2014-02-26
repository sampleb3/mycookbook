#
# Cookbook Name:: mycookbook
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# -----------------------------------------------------------------
# basic package
%w{ntp vim wget}.each do |pkg|
  package pkg do
    action :install
  end
end

# -----------------------------------------------------------------
# TimeZone
bash 'timezone change' do
  user 'root'
  code <<-EOF
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime -f
  EOF
end

# -----------------------------------------------------------------
# NTP
service "ntpd" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "ntpd")
end

# -----------------------------------------------------------------
# iptables OFF
service "iptables" do
  supports :status => true, :restart => true, :reload => true
  action [:disable, :stop]
end

# -----------------------------------------------------------------
# webmin
yum_repository "webmin" do
  url "http://download.webmin.com/download/yum"
  gpgkey 'http://www.webmin.com/jcameron-key.asc'
  action :add
end

%w{webmin openssl openssl-devel zlib-devel readline-devel cpan}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

service "webmin" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

cpan_client 'Net::SSLeay' do
    action 'install'
    install_type 'cpan_module'
    user 'root'
    group 'root'
end

template "/etc/webmin/miniserv.conf" do
  source "miniserv.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "webmin")
end

# -----------------------------------------------------------------
# 公開鍵認証
group node['settings']['user'] do
  group_name node['settings']['group']
  action     [:create]
end

user node['settings']['user'] do
  shell    '/bin/bash'
  password node['settings']['user_password']
  group    node['settings']['group']
  supports :manage_home => true, :non_unique => false
  action   [:create]
end

directory "/home/#{node['settings']['user']}/.ssh" do
  owner node['settings']['user']
  group node['settings']['group']
  mode  0700
end

file "authorized_keys" do
  path "/home/#{node['settings']['user']}/.ssh/authorized_keys"
  content node['settings']['ssh_key']
  owner node['settings']['user']
  mode  0600
end

# ssh設定
service "sshd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "sshd")
end

# sudo
template "/etc/sudoers" do
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
  variables({
     :sudoers_users => node[:settings][:sudo_users]
  })
end

