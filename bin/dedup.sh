#!/bin/bash

nova_pwd=$(grep nova_database_password /etc/kolla/passwords.yml | cut -f2 -d ' ')
plcm_pwd=$(grep placement_database_password /etc/kolla/passwords.yml | cut -f2 -d ' ')

sudo systemctl stop kolla-nova_compute-container.service
docker exec -it mariadb mysql -u nova --password=$nova_pwd -D nova -e "delete from compute_nodes;"
docker exec -it mariadb mysql -u nova --password=$nova_pwd -D nova -e "delete from services where topic = 'compute';"
docker exec -it mariadb mysql -u placement --password=$plcm_pwd -D placement -e "delete from resource_provider_traits;"
docker exec -it mariadb mysql -u placement --password=$plcm_pwd -D placement -e "update resource_providers set root_provider_id=NULL;"
docker exec -it mariadb mysql -u placement --password=$plcm_pwd -D placement -e "delete from resource_providers;"
sudo systemctl start kolla-nova_compute-container.service

