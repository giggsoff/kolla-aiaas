# Kolla-Ansible OpenStack setup for AIaaS 

Kolla install/config instructions:
* https://docs.openstack.org/kolla-ansible/latest/user/quickstart.html
* https://docs.openstack.org/kolla/latest/admin/index.html

Makefile main actions:
* `make init` -- configure kolla-build and initialize kolla-ansible.
* `make build` (deafult) -- build `horizon` and `nova-compute`
* `make deploy` -- deploy Docker images
* `make destroy` -- destroy all kolla-related Docker images
* `make pull` -- just pull kolla-related from standard repositories

EDEN node configuring parameters:
* `eden_host` -- Host to be used to communicate with EDEN tool (default='eden').
* `eden_port` -- SSH port to be used to communicate with EDEN tool (default='22').
* `eden_user` -- User to be used to run EDEN tool (default='eden').
* `eden_password` -- EDEN user's password (default='').
* `eden_key_file` -- SSH certificate file to be verified in EDEN host. A string, it must be a path to a SSH private key to use (default='/var/lib/nova/.ssh/eden_rsa').
* `eden_dir` -- The path at which EDEN executable will run. A file system path on the host running the compute service (default="~/eden/").
* `image_tmp_path` -- The path at which images will be stored. Images need to be stored on the local disk of the compute host. This configuration identifies the directory location. Possible values: a file system path on the host running the compute service (default="/tmp").
* `eden_tmp_path` -- The path at which images will be stored. Images need to be stored on the local disk of the EDEN host. This configuration identifies the directory location. Possible values: a file system path on the host running the compute service (default="/tmp").

Example of using in `all-in-one` inventory
```
# These initial groups are the only groups required to be modified. The
# additional groups are for more control of the environment.
[control]
localhost       ansible_connection=local
...
[compute]
localhost       ansible_connection=local eden_host="192.168.10.22" eden_password="Adam&Eve"
...
```
