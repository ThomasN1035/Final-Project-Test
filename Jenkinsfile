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
        stage('Check Docker Daemon Version') {
            steps {
                sh '''
                    # Extract server API version using docker version format
                    API_VERSION=$(docker version --format '{{.Server.APIVersion}}')
                    
                    if [ -z "$API_VERSION" ]; then
                        echo "Error: Could not retrieve Docker server API version."
                        exit 1

                    fi
                    
                    echo "Detected Docker Server API Version: $API_VERSION"
                    
                    # Compare version numbers using awk
                    HAS_MIN_VERSION=$(echo "$API_VERSION 1.44" | awk '{if ($1 >= $2) print "yes"; else print "no"}')
                    
                    if [ "$HAS_MIN_VERSION" = "no" ]; then
                        echo "Error: Docker daemon API version $API_VERSION is below the required 1.44 minimum."
                        exit 1
                    else
                        echo "Docker daemon version check passed."
                    fi
                '''
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-local-app:latest .'
            }
        }

        stage('Terraform Deploy') {
            steps {
                script {
                    // Download Terraform binary inside the build environment if not present
                    sh '''
                    if [ ! -f terraform ]; then
                        # Use curl to download the actual Linux binary zip
                        curl -fsSL https://releases.hashicorp.com/terraform/1.15.8/terraform_1.15.8_linux_amd64.zip -o terraform.zip
                        unzip -o terraform.zip
                        chmod +x terraform
                        rm -f terraform.zip
                    fi
                    ./terraform init
                    ./terraform apply -auto-approve
                    '''
                }
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
