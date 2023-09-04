#!/bin/bash

. /etc/kolla/admin-openrc.sh 

# Just check
openstack hypervisor list | grep eve_os || exit -1

# Create image
VERSION=$(curl -s http://download.cirros-cloud.net/version/released)

wget -c http://download.cirros-cloud.net/$VERSION/cirros-$VERSION-x86_64-disk.img

openstack image create \
 --container-format bare \
 --disk-format qcow2 \
 --file cirros-$VERSION-x86_64-disk.img \
 Cirros

# Create external network
openstack network create ext-net --external --provider-physical-network physnet1 --provider-network-type flat
openstack subnet create ext-subnet --no-dhcp --allocation-pool start=172.16.0.2,end=172.16.0.249 --network=ext-net --subnet-range 172.16.0.0/24 --gateway 172.16.0.1

# Create default flavors.
openstack flavor create --public m1.tiny --ram 512 --disk 1 --vcpus 1
openstack flavor create --public m1.small --ram 2048 --disk 20 --vcpus 1
openstack flavor create --public m1.medium --ram 4096 --disk 40 --vcpus 2
openstack flavor create --public m1.large --ram 8192 --disk 80 --vcpus 4
openstack flavor create --public m1.xlarge --ram 16384 --disk 160 --vcpus 8

# Create a demo tenant network, router and security group.
openstack network create demo-net
openstack subnet create demo-subnet --allocation-pool start=192.168.0.2,end=192.168.0.254 --network demo-net --subnet-range 192.168.0.0/24 --gateway 192.168.0.1 --dns-nameserver 8.8.8.8 --dns-nameserver 8.8.4.4
openstack router create demo-router

neutron router-interface-add demo-router $(openstack subnet show demo-subnet -c id -f value)
neutron router-gateway-set demo-router ext-net

openstack keypair create demo-key > ./stackanetes.id_rsa

openstack server list

openstack server create --flavor m1.tiny --key-name demo-key --network demo-net --image Cirros demo1

openstack server list

openstack server delete demo1

openstack server list

