#
# Cookbook Name:: mycookbook
# Recipe:: mysqldb
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'database::mysql'

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

mysql_database node['mysqldb']['database_name'] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node['mysqldb']['database_user'] do
  connection mysql_connection_info
  password node['mysqldb']['database_user_password']
  database_name node['mysqldb']['database_name']
  privileges [:all]
  action [:create, :grant]
end

service "mysqld" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

template "/etc/my.cnf" do
  source "my.cnf.erb"
  mode "0644"
  notifies :reload, 'service[mysqld]'
end
