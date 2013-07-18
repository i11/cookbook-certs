#
# Cookbook Name:: certs
# Attributes:: default
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

default[:certs][:path]                 = '/etc/pki/klarna'
default[:certs][:owner]                = 'root'
default[:certs][:group]                = 'root'
default[:certs][:mode]                 = '0444'
default[:certs][:template_source]      = 'file.erb'
default[:certs][:ca_name]              = 'klarna-ca'
default[:certs][:data_bag_shared_keys] = 'shared_keys'
default[:certs][:data_bag_certs]       = :certs
