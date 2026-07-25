FROM nginx:alpine
COPY app/index.html /usr/share/nginx/html/index.html
EXPOSE 80
FROM jenkins/jenkins:lts

USER root

# Clean out old cache lists and forcefully update repository mappings
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get update --allow-releaseinfo-change && \
    apt-get install -y --fix-missing \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        wget \
        software-properties-common

# Install Docker CLI
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://docker.com | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Install Terraform
RUN curl -fsSL https://hashicorp.com | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform

USER jenkins
