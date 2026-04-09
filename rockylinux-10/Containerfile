FROM  rockylinux/rockylinux:10-ubi-init

RUN dnf -y install python3-pip \
    && dnf clean all

COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
