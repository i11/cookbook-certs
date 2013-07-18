#
# Cookbook Name:: certs
# Provider:: ca
#
# Author:: Ilja Bobkevic <ilja.bobkevic@klarna.com>
# Copyright 2013, Klarna
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

def load_current_resource
  @current_resource = Chef::Resource::CertsCa.new(new_resource.ca_name)
end

action :create do
  Certs.create_ca(node, run_context, new_resource.ca_name)
  new_resource.updated_by_last_action(true)
end

action :delete do
  Certs.delete_file("#{node[:certs][:path]}#{new_resource.ca_name}.cert")
  new_resource.updated_by_last_action(true)
end
