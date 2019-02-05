#!/usr/bin/env bash

# Fetch Images and tools for juju to use 
juju sync-tools --debug

# Create the Bootstrap instance
juju bootstrap --upload-tools --debug

# Deploy the OpenStack Charms
juju deploy --to=0 juju-gui
juju deploy rabbitmq-server
juju deploy mysql
juju deploy --config openstack-config.yaml openstack-dashboard
juju deploy --config openstack-config.yaml keystone
juju deploy --config openstack-config.yaml ceph -n 3 
juju deploy --config openstack-config.yaml nova-compute -n 3
juju deploy --config openstack-config.yaml quantum-gateway
juju deploy --config openstack-config.yaml cinder
juju deploy --config openstack-config.yaml nova-cloud-controller
juju deploy --config openstack-config.yaml glance
juju deploy --config openstack-config.yaml ceph-radosgw

# Add relations between the OpenStack services
juju add-relation keystone mysql
juju add-relation nova-cloud-controller mysql
juju add-relation nova-cloud-controller rabbitmq-server
juju add-relation nova-cloud-controller glance
juju add-relation nova-cloud-controller keystone
juju add-relation nova-compute mysql
juju add-relation nova-compute rabbitmq-server
juju add-relation nova-compute glance
juju add-relation nova-compute nova-cloud-controller
juju add-relation glance mysql
juju add-relation glance keystone
juju add-relation cinder keystone
juju add-relation cinder mysql
juju add-relation cinder rabbitmq-server
juju add-relation cinder nova-cloud-controller
juju add-relation openstack-dashboard keystone
juju add-relation swift-proxy swift-storage
juju add-relation swift-proxy keystone
