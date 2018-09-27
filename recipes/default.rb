#
# Cookbook Name:: UNMS_server
# Recipe:: default
#
# Copyright (c) 2018 Telmate LLC, All Rights Reserved.

#install required packages
#packages = %w(curl sudo bash netcat)

#packages.each do |p|
#    packages p
#end

#install docker
docker_service 'default' do
   action [:create, :start]
end

#download UNMS server.
remote_file '/tmp/unms_inst.sh' do
    source 'https://unms.com/install'
    action :nothing
end

#check to see if there is an update to the server.
http_request 'HEAD https://unms.com/install' do
  message ''
  url 'https://unms.com/install'
  action :head
  if ::File.exist?('/tmp/unms_inst.sh')
    headers 'If-Modified-Since' => File.mtime('/tmp/unms_inst.sh').httpdate
  end
  notifies :create, 'remote_file[/tmp/unms_inst.sh]', :immediately
end

#install the server. 
bash 'install_UNMS' do
    cwd ::File.dirname('/tmp/')
    code <<-EOH
    sudo bash /tmp/unms_inst.sh  --unattended
    EOH
end
