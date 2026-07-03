FROM debian:stable@sha256:9631e4628fccfb6f1ff9e27de2af0e82f61591c78d1584c778f92db9a541a3cc

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    ca-certificates \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
       | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y \
       docker-ce docker-ce-cli containerd.io \
       docker-buildx-plugin docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt


CMD ["/bin/sh", "-c", "cd ${INPUT_MOLECULE_WORKING_DIR} && molecule ${INPUT_MOLECULE_OPTIONS} ${INPUT_MOLECULE_COMMAND} ${INPUT_MOLECULE_ARGS}"]
