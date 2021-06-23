FROM alpine:3.12

LABEL maintainer="leafnode@gmail.com" \
      org.label-schema.docker.cmd="docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa leafnode/ansible:4.1.0-alpine-3.12" \
      org.label-schema.url="https://github.com/leafnode/docker-ansible" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="leafnode/ansible" \
      org.label-schema.description="Docker image for running Ansible playbooks" \
      org.label-schema.url="https://github.com/leafnode/docker-ansible" \
      org.label-schema.vcs-url="https://github.com/leafnode/docker-ansible"

RUN apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git

RUN apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        openssl-dev \
        libressl-dev \
        build-base

RUN pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi && \
    pip3 install ansible==4.1.0 && \
    pip3 install mitogen ansible-lint jmespath && \
    pip3 install --upgrade pywinrm

RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]