# Usage: 
# docker build -t awx:latest .
# docker run -itd --name awx -v "${PWD}:/remote/" --env-file <env-file> awx:latest 

#FROM cytopia/ansible:2.9-tools
FROM ubuntu:20.04

ARG ANSIBLE_VER=2.9.10

LABEL description="AWX Installation with Ansible"
LABEL maintainer="Pablo Lencinas <plencina@cisco.com>"
LABEL version="0.1"

ENV PLAYBOOK=main.yaml
ENV TARGET_HOST=test_host
ENV INVENTORY_FILE=inventory/hosts
ENV EXTRA_VARS_FILE=extra_vars.yml

COPY ./ /awx
WORKDIR /awx

RUN apt-get update && apt-get -qqy upgrade
RUN apt-get -y install make nano curl cron git python-dev python3-dev
RUN apt-get -y install python3 python3-pip

RUN echo "**** install Ansible and dependencies ****" && \
  pip3 install --no-cache-dir -r requirements.txt

#install docker-compose
#RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

#Install Ansible
RUN pip3 install ansible

#Install minikube
#RUN curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
#RUN install minikube-linux-arm64 /usr/local/bin/minikube


CMD ansible-playbook $PLAYBOOK -vvv -i $INVENTORY_FILE


# docker run -it --name greenmaker -v "${PWD}:/remote/" greenmaker:latest bash