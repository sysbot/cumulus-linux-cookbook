#
# Author:: Bao Nguyen <ngqbao@gmail.com>
# Cookbook Name:: cumulus-linux
# Recipe:: as6071_32x
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

include_recipe "ooyala-cumulus-linux"

# we want to make sure this only happen when port config changes
template "/etc/cumulus/ports.conf" do
  source "accton_as6701_32x_ports.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[switchd]", :delayed
end

service "switchd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :restart ]
end