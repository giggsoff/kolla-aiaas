# Kolla-Ansible OpenStack setup for AIaaS 

Kolla install/config instructions:
* https://docs.openstack.org/kolla-ansible/latest/user/quickstart.html
* https://docs.openstack.org/kolla/latest/admin/index.html

Makefile main actions:
* make init -- configure kolla-build and initialize kolla-ansible.
* make build (deafult) -- build `horizon` and `nova-compute`
* make deploy -- deploy Docker images
* make destroy -- destroy all kolla-related Docker images
* make pull -- just pull kolla-related from standard repositories
