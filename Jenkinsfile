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
                        echo "Docker CLI not found. Installing via built-in system repository..."
                        sh '''
                            apt-get update && \
                            apt-get install -y docker.io
                        '''
                        echo "Docker CLI successfully installed from native repositories."
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
