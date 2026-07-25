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
                        echo "Docker CLI not found. Downloading static binary..."
                        // Create a local bin directory in the workspace
                        sh 'mkdir -p bin'
                        
                        // Download the official static Docker CLI binary (Linux x86_64)
                        sh '''
                            curl -fsSL https://docker.com -o docker.tgz
                            tar -xzvf docker.tgz docker/docker --strip-components=1 -C bin/
                            rm docker.tgz
                            chmod +x bin/docker
                        '''
                        echo "Docker CLI successfully installed locally in workspace."
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
