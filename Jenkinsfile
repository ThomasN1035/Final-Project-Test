pipeline {
    agent any

    environment {
        // Adds the workspace bin folder to PATH so the downloaded docker binary is accessible
        PATH = "${WORKSPACE}/bin:${env.PATH}"
    }

    options {
        timeout(time: 1, unit: 'HOURS')
    }

    stages {
        stage('Initialize & Verify Tools') {
            steps {
                script {
                    def dockerExists = sh(script: 'command -v docker', returnStatus: true) == 0
                    
                    if (!dockerExists) {
                        echo "Docker CLI not found. Installing via apt-get..."
                        sh '''
                            apt-get update && \
                            apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
                            mkdir -p /etc/apt/keyrings && \
                            curl -fsSL https://docker.com | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg && \
                            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://docker.com $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
                            apt-get update && \
                            apt-get install -y docker-ce-cli
                        '''
                        echo "Docker CLI successfully installed via official repositories."
                } else {
                    echo "Docker CLI is already available on the system."
                }
            }
        }
    }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t local-app:latest .'
            }
        }

        stage('Terraform Deploy') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
