pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven"
    }

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_IMAGE = 'khanhash1992/e-commerce'
        KUBE_CONFIG = credentials('kubeconfig')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/khangar-harish/e-commerce.git'
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    def services = ['user-service', 'product-service', 'order-service']
                    for (service in services) {
                        dir(service) {
                            sh 'mvn clean install'
                        }
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    def services = ['user-service', 'product-service', 'order-service']
                    for (service in services) {
                        dir(service) {
                            sh "docker build -t ${DOCKER_IMAGE}-${service}:latest ."
                        }
                    }
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    def services = ['user-service', 'product-service', 'order-service']
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        for (service in services) {
                            sh "docker push ${DOCKER_IMAGE}-${service}:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def services = ['user-service', 'product-service', 'order-service']
                    for (service in services) {
                        sh "kubectl set image deployment/${service}-deployment ${service}=${DOCKER_IMAGE}-${service}:latest --kubeconfig=${KUBE_CONFIG}"
                    }
                }
            }
        }
    }

    //  post {
    //     always {
    //         cleanWs()
    //     }
    // }
}
