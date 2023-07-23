KOLLA_ANSIBLE = kolla-ansible -i all-in-one
KOLLA_BUILD = kolla-build -b ubuntu 

build: horizon nova deploy

init:
	#cp etc/kolla/globals.yml /etc/kolla/
	cp etc/kolla/kolla-build.conf /etc/kolla/
	$(KOLLA_ANSIBLE) bootstrap-servers
	$(KOLLA_ANSIBLE) prechecks

horizon:
	$(KOLLA_BUILD) horizon

nova:
	$(KOLLA_BUILD) nova-compute

deploy:
	bin/images2registry.sh
	$(KOLLA_ANSIBLE) prune-images --yes-i-really-really-mean-it
	$(KOLLA_ANSIBLE) deploy
	$(KOLLA_ANSIBLE) post-deploy

destroy:
	$(KOLLA_ANSIBLE) destroy --include-images --include-dev --yes-i-really-really-mean-it

pull:
	$(KOLLA_ANSIBLE) pull
