#!/usr/bin/env bash

if [ $# -gt 0 ]; then

    if [ "$1" == "provision" ]; then
        COMMAND="apply --auto-approve"

    elif [ "$1" == "config" ]; then
        docker run -it --rm \
            -v $PWD:/opt \
            -w /opt \
            tombenevides/ansible:latest \
            ansible-playbook \
            -u ubuntu -i ansible/hosts \
            --private-key ./.pk/olw_pk.pem \
            ansible/playbook.yml

        exit 0

    elif [ "$1" == "build" ]; then
        ./sail provision && ./sail config

        exit 0
        
    else
        COMMAND="$@"
    fi
else
    COMMAND=""
fi

docker run -it --rm \
    -u $(id -u):$(id -g) \
    --env-file ./.env \
    -v $PWD:/workspace \
    -w /workspace \
    hashicorp/terraform:light $COMMAND