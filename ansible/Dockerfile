FROM ubuntu:20.04

WORKDIR /opt

RUN apt-get update && apt-get install -y software-properties-common

RUN apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y ansible