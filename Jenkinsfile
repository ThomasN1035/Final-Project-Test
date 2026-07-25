pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-local-app:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls code from your GitHub repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Builds the application image locally
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                script {
                    // Download Terraform binary inside the build environment if not present
                    sh '''
                    if [ ! -f terraform ]; then
                        wget https://hashicorp.com
                        unzip terraform_1.5.7_linux_amd64.zip
                        rm terraform_1.5.7_linux_amd64.zip
                     Block
                    fi
                    '''
                    // Execute deployment
                    sh './terraform init'
                    sh './terraform apply -auto-approve'
                }
            }
        }
    }
}
