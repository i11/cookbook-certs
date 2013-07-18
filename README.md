certs Cookbook
==============

certs cookbook purpose is to provide an easy way for installing defined SSL certificates
in a convenient manner. Certificates should be stored in encrypted data bags protected
by shared keys. Cookbook contains LWRP only, there are no recipes present.

Requirements
------------

#### data bags
- shared_keys (attribute node[:certs][:data_bag_shared_keys])
- certs (attribute node[:certs][:data_bag_certs])

License and Authors
-------------------
Authors: Ilja Bobkevic <ilja.bobkevic@klarna.com>
Encryption implementation is basd on: https://gist.github.com/hh/4949041 by Chris McClimans
