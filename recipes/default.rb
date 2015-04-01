#
# Cookbook Name:: fail2ban
# Recipe:: default
#
# Copyright 2009-2011, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# epel repository is needed for the fail2ban package on rhel
include_recipe 'yum-epel' if platform_family?('rhel')

package 'unzip'

bash "install_fail2ban" do
  user "root"
  cwd "/tmp"
  code "
  wget https://github.com/fail2ban/fail2ban/archive/#{ node.fail2ban.version }.zip
  unzip #{ node.fail2ban.version }.zip
  cd fail2ban-#{ node.fail2ban.version }
  python setup.py install
  "
  not_if "which fail2ban-client"
end

cookbook_file "/etc/fail2ban/action.d/ufw-new.conf" do
  source "ufw-new.conf"
end

node['fail2ban']['filters'].each do |name, options|
  template "/etc/fail2ban/filter.d/#{name}.conf" do
    source "filter.conf.erb"
    variables(:failregex => [options['failregex']].flatten, :ignoreregex => [options['ignoreregex']].flatten)
    notifies :restart, 'service[fail2ban]'
  end
end

template '/etc/fail2ban/fail2ban.conf' do
  source 'fail2ban.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[fail2ban]'
end

node['fail2ban']['jails'].each do |name, jail|
  template "/etc/fail2ban/jail.d/#{name}.local" do
    source "jail.local.erb"
    variables(:name => name, :jail => jail)
    notifies :restart, 'service[fail2ban]'
  end
end

service 'fail2ban' do
  supports [:status => true, :start => true, :stop => true]
  start_command "fail2ban-client start"
  stop_command "fail2ban-client stop"
  reload_command "fail2ban-client reload"
  status_command "fail2ban-client status | grep -v -c running"
end

service "fail2ban" do
  action [:start]
  not_if "fail2ban-client status | grep -v -c running"
end


