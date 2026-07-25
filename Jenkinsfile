pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-local-app:latest"
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
