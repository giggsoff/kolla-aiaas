KOLLA_ANSIBLE = kolla-ansible -i all-in-one -vvvv
KOLLA_BUILD = kolla-build -b ubuntu -d

build: horizon nova deploy

init:
	cp -i etc/kolla/globals.yml /etc/kolla/
	cp -i etc/kolla/kolla-build.conf /etc/kolla/
	$(KOLLA_ANSIBLE) bootstrap-servers
	$(KOLLA_ANSIBLE) prechecks
	bin/set_virt kvm eve_os
	$(KOLLA_ANSIBLE) deploy
	$(KOLLA_ANSIBLE) post-deploy

horizon:
	$(KOLLA_BUILD) horizon

nova_patch:
	bin/patch_nova

nova_compute:
	$(KOLLA_BUILD) nova-compute #--nouse-dumb-init

nova: nova_patch nova_compute
	$(KOLLA_BUILD) nova-api
	$(KOLLA_BUILD) nova-scheduler
	$(KOLLA_BUILD) nova-conductor
	$(KOLLA_BUILD) nova-libvirt
	$(KOLLA_BUILD) nova-novncproxy
	$(KOLLA_BUILD) nova-serialproxy
	$(KOLLA_BUILD) nova-ssh

deploy:
	bin/images2registry.sh
	$(KOLLA_ANSIBLE) prune-images --yes-i-really-really-mean-it
	bin/set_virt kvm eve_os
	$(KOLLA_ANSIBLE) deploy
	$(KOLLA_ANSIBLE) post-deploy
	bin/set_virt eve_os kvm
	$(KOLLA_ANSIBLE) reconfigure

destroy:
	$(KOLLA_ANSIBLE) stop --yes-i-really-really-mean-it
	$(KOLLA_ANSIBLE) destroy --include-images --include-dev --yes-i-really-really-mean-it

pull:
	$(KOLLA_ANSIBLE) pull

reconfigure:
	$(KOLLA_ANSIBLE) reconfigure
