sudo apt install docker
FROM nginx:alpine
COPY app/ /usr/share/nginx/html/
EXPOSE 80

FROM jenkins/jenkins:lts
USER root
# Install the Docker CLI
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSL https://docker.com | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://docker.com $(lsb_release -cs) stable" | tee /etc/apt/sources.list.data/docker.list > /dev/null
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
