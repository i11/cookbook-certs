#
# Cookbook Name:: certs
# Library:: certs
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

module Certs

  class << self

    def create_ca(node, rc, ca_name)
      create_file(node, rc, "#{ca_name}.cert", get_data_bag(node[:certs][:data_bag_certs], ca_name)[:cert])
    end

    def create_cert(node, rc, cert_name, ext)
      create_file(
        node,
        rc,
        "#{cert_name}.#{ext}",
        get_encrypted_data_bag(
          node[:certs][:data_bag_shared_keys],
          node[:certs][:data_bag_certs],
          cert_name,
          node.name
        )[ext]
      )
    end

    def delete_file(full_path)
      File.delete(full_path) if File.exists?(full_path)
    end

    private

    def create_file(node, rc, file_name, content)
      Dir.mkdir(node[:certs][:path]) unless File::directory?(node[:certs][:path])
      t = Chef::Resource::Template.new("#{node[:certs][:path]}/#{file_name}")
      t.source(node[:certs][:template_source])
      t.owner(node[:certs][:owner])
      t.group(node[:certs][:group])
      t.mode(node[:certs][:mode])
      t.cookbook('certs')
      t.variables(
        :content => content
      )
      t.run_context = rc
      t.run_action(:create)
    end

    def get_data_bag(data_bag, data_bag_item)
      Mash.from_hash(Chef::DataBagItem.load(data_bag, data_bag_item).to_hash)
      rescue Net::HTTPServerException => e
        raise Nexus::EncryptedDataBagNotFound.new(data_bag)
    end

    #
    # Based on https://gist.github.com/hh/4949041
    #
    def get_encrypted_data_bag(data_bag_shared_key, data_bag_certs, data_bag_item, node_name)
      data_bag_item = data_bag_item.gsub('.', '_')
      public_encrypted_secret = Base64.decode64(Chef::DataBagItem.load(data_bag_shared_key, data_bag_item)[node_name])

      # use the private client_key file to create a decryptor
      pkey = OpenSSL::PKey::RSA.new(open(Chef::Config[:client_key]).read())

      # the private client_key is then used to decrypt data encrypted with the public_key
      encrypted_data_bag_secret = pkey.private_decrypt public_encrypted_secret

      Mash.from_hash(Chef::EncryptedDataBagItem.load(data_bag_certs, data_bag_item, encrypted_data_bag_secret).to_hash)
      rescue Net::HTTPServerException => e
      raise Nexus::EncryptedDataBagNotFound.new(data_bag_certs)
    end
  end
end
