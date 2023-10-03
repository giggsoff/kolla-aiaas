#!/bin/sh

#TAG='2023.1-ubuntu-jammy'
TAG='2023.1-rocky-9'
#TAG='master-rocky-9'

docker images | grep '^kolla\/' | awk '{print $1,$2}' | while read -r image tag
do
    new_image_name=${image#"kolla/"}
    echo docker tag ${image}:${tag} 'quay.io/openstack.kolla/'${new_image_name}:${TAG} && \
    docker tag ${image}:${tag} 'quay.io/openstack.kolla/'${new_image_name}:${TAG}
done
