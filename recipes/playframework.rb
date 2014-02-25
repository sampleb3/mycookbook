#
# Cookbook Name:: mycookbook
# Recipe:: playframework
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{unzip}.each do |pkg|
  package pkg do
    action :install
  end
end

# ユーザとグループの作成

group node['playframework']['group'] do
  group_name node['playframework']['group']
  action     [:create]
end

user node['playframework']['user'] do
  shell    '/bin/bash'
  password node['playframework']['user_password']
  group    node['playframework']['group']
  supports :manage_home => true, :non_unique => false
  action   [:create]
end

# Play framework インストール
version = node['playframework']['version']
if ::Dir.exist?("#{node['playframework']['play_dir']}/play-#{version}")

  directory node['playframework']['play_dir'] do
    owner node['playframework']['user']
    group node['playframework']['group']
    mode "0775"
    action :create
  end

  version_data = version.split('.')
  cache_path = Chef::Config[:file_cache_path]
  zip_file_url = ''
  zip_file_name = "play-#{version}.zip"
  zip_file_url = "http://downloads.typesafe.com/play/#{version}/#{zip_file_name}"
  zip_ex_dir_name = "play-#{version}"

  execute "echo" do
    command "echo #{zip_file_url}"
  end

  remote_file "#{cache_path}/#{zip_file_name}" do
    source zip_file_url
    mode "0644"
  end

  bash "extract play zip" do
    cwd node['playframework']['play_dir']
    code <<-BASH
    unzip #{cache_path}/#{zip_file_name}
    chown -R #{node['playframework']['user']}:#{node['playframework']['group']} .
    BASH
  end

  bash "add bash path" do
    not_if "which play"
    user 'root'
    code <<-BASH
      echo "export PATH=#{node['playframework']['play_dir']}/#{zip_ex_dir_name}":$PATH" >> /etc/bashrc
    BASH
  end

end
