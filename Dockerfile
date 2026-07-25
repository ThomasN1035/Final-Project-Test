FROM nginx:alpine
COPY app/index.html /usr/share/nginx/html/index.html
EXPOSE 80
FROM jenkins/jenkins:lts

USER root

# Install tools, Docker CLI, and wget
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release wget software-properties-common

# Install Terraform officially
RUN curl -fsSL https://hashicorp.com | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform

USER jenkins
