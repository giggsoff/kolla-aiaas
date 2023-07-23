#!/bin/sh

docker images | grep '^kolla\/' | awk '{print $1,$2}' | while read -r image tag
do
    new_image_name=${image#"kolla/"}
    echo docker tag ${image}:${tag} 'quay.io/openstack.kolla/'${new_image_name}:2023.1-ubuntu-jammy && \
    docker tag ${image}:${tag} 'quay.io/openstack.kolla/'${new_image_name}:2023.1-ubuntu-jammy # && \
    #echo docker push quay.io/openstack.kolla/${new_image_name}:2023.1-ubuntu-jammy && \
    #docker push quay.io/openstack.kolla/${new_image_name}:2023.1-ubuntu-jammy
done
