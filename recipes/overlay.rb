#
# Author:: Bao Nguyen <ngqbao@gmail.com>
# Cookbook Name:: cumulus-linux
# Recipe:: overlay
#
# Copyright 2014, Bao Nguyen
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

# "build" a cumulus switch overlay on a standard Debian system

interfaces = Cumulus::AS6701_32X::Ports.new()

(21..24).each do |i|
  interfaces.set_10G(i)
end

directory "/etc/cumulus" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# read and create the port mapping
template "/etc/cumulus/ports.conf" do
  source "ports.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    ports: interfaces.ports,
    x_pipline: interfaces.get_x,
    y_pipeline: interfaces.get_y
  )
end

# build the "physical" interfaces
execute "dummy" do
  command "modprobe dummy numdummies=#{interfaces.ports.length}"
  action :run
end

# TODO: convert to chef HWRP
#ip_link "swp1" do
#  dev "dummy0"
#  action :add
#  status :up
#  type :dummy
#end

# simulating front panel ports
(0..interfaces.ports.length-1).each do |i|
  execute "links" do
    command "/sbin/ip link set name swp#{i} dev dummy#{i}"
    action :run
    not_if "/sbin/ip link show swp#{i}"
  end
end

# only needed to simulate switchd daemon
gem_package "daemons"

# start the fake "switchd"
template "/etc/init.d/switchd" do
  source "switchd.conf.init.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "usr/sbin/switchd_control.rb" do
  source "switchd_control.rb.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/usr/sbin/switchd.rb" do
  source "switchd.rb.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "switchd" do
  supports :status => false, :restart => true, :reload => false
  action [ :start ]
end
