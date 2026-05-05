FROM rockylinux/rockylinux:10-ubi@sha256:505425723e64988f3b2cbf640cdb576597f5e427bc9716a516a6673e49464eb6

RUN dnf -y install python3-pip \
    && dnf clean all

COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
