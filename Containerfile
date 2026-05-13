FROM rockylinux/rockylinux:10-ubi@sha256:505425723e64988f3b2cbf640cdb576597f5e427bc9716a516a6673e49464eb6

RUN dnf -y install \
    python3-pip \
    podman \
    && dnf clean all

COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# RUN ansible-galaxy collection install containers.podman
RUN sudo dnf remove -y docker docker-client docker-client-latest docker-common \
    docker-latest docker-latest-logrotate docker-logrotate docker-engine \
    podman runc

RUN sudo dnf -y install dnf-plugins-core

RUN sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo


RUN sudo dnf -y install docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin

RUN systemctl enable --now docker

CMD ["/bin/sh", "-c", "cd ${INPUT_MOLECULE_WORKING_DIR} && molecule ${INPUT_MOLECULE_OPTIONS} ${INPUT_MOLECULE_COMMAND} ${INPUT_MOLECULE_ARGS}"]
