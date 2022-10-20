#!/usr/bin/env bash

docker run -it --rm \
    --env-file ./.env \
    -v $PWD:/workspace \
    -w /workspace \
    hashicorp/terraform:light "$@"