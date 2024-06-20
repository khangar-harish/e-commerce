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
                git(
                    url: 'https://github.com/khangar-harish/e-commerce.git',
                    branch: 'main'
                )
            }
        }

        stage('Deploy MySQL') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'kubeconfig')]) {
                        // Apply ConfigMaps and Secrets for MySQL
                        sh "kubectl apply -f k8s/mysql-secrets.yaml --kubeconfig=${kubeconfig}"
                        sh "kubectl apply -f k8s/mysql-configMap.yaml --kubeconfig=${kubeconfig}"
                        sh "kubectl apply -f k8s/mysql-service-deployment.yaml --kubeconfig=${kubeconfig}"
                        
                        // Deploy MySQL
                        // def services = ['user-service', 'product-service', 'order-service']
                        // for (service in services) {
                        //     sh "kubectl apply -f k8s/${service}-mysql-deployment.yaml --kubeconfig=${kubeconfig}"
                        // }
                    }
                }
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    def services = ['user-service', 'product-service', 'order-service', 'eureka-server', 'api-gateway']
                    for (service in services) {
                        dir(service) {
                            sh 'printenv'
                            sh ' mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    def services = ['user-service', 'product-service', 'order-service', 'eureka-server', 'api-gateway']
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
                    withCredentials([string(credentialsId: 'DockeHub', variable: 'dockerpwd')]) {
                        sh 'echo $dockerpwd | docker login -u khanhash1992 --password-stdin'
                    }
                    def services = ['user-service', 'product-service', 'order-service', 'eureka-server', 'api-gateway']
                    for (service in services) {
                        sh "docker push ${DOCKER_IMAGE}-${service}:latest"
                    }
                }
            }
        }

        stage('Deploy Services to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'kubeconfig')]) {
                        def services = ['user-service', 'product-service', 'order-service', 'eureka-server', 'api-gateway']
                        for (service in services) {
                            sh "kubectl apply -f k8s/${service}-deployment.yaml --kubeconfig=${kubeconfig}"
                        }
                    }
                }
            }
        }
    }

     post {
        always {
            cleanWs()
        }
    }
}
