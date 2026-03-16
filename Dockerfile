FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        curl && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Docker
ARG DOCKER_BUILDX_PLUGIN_VERSION="0.31.1-1"
ARG DOCKER_CLI_VERSION="5:29.3.0-1"
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=${TARGETARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        docker-buildx-plugin=${DOCKER_BUILDX_PLUGIN_VERSION}~ubuntu.24.04~noble \
        docker-ce-cli=${DOCKER_CLI_VERSION}~ubuntu.24.04~noble && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# AECH (Amazon ECR Credential Helper)
ARG AECH_VERSION="0.12.0"
RUN cd /tmp && \
    curl -fSL -o "docker-credential-ecr-login" "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${AECH_VERSION}/linux-${TARGETARCH}/docker-credential-ecr-login" && \
    curl -fSL -o "docker-credential-ecr-login.sha256" "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${AECH_VERSION}/linux-${TARGETARCH}/docker-credential-ecr-login.sha256" && \
    cat "docker-credential-ecr-login.sha256" | sha256sum -c - && \
    chmod +x "./docker-credential-ecr-login" && \
    mv "./docker-credential-ecr-login" "/usr/local/bin/docker-credential-ecr-login" && \
    rm -rf /tmp/*

# Create user
ARG APP_USER="builder"
RUN groupadd -g 1001 ${APP_USER} && \
    useradd --create-home -u 1001 -g 1001 ${APP_USER}

WORKDIR /home/${APP_USER}
USER ${APP_USER}:${APP_USER}
CMD ["/bin/bash"]
