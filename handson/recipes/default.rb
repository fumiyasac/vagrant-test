#
# Cookbook Name:: handson
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"

apache_site "000-default" do
	enable false
end

directory "/srv/static" do
    owner "www-data"
    group "www-data"
    action :create
    mode 00700
end

template "#{node[:handson][:document_root]}/index.html" do
    source "index.html.erb"
    owner "www-data"
    group "www-data"
    mode 00766
end
template "#{node[:apache][:dir]}/sites-available/#{node[:handson][:config]}" do
	source "apache2.conf.erb"
	notifies :restart, 'service[apache2]'
end

apache_site node[:handson][:config] do
	enable true
end

include_recipe "handson::database"

include_recipe "handson::php"