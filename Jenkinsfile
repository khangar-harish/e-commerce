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
                    withCredentials([string(credentialsId: 'DockeHub', variable: 'dockerpwd')]) {
                        sh 'echo $dockerpwd | docker login -u khanhash1992 --password-stdin'
                    }
                    def services = ['user-service', 'product-service', 'order-service']
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
                        def services = ['user-service', 'product-service', 'order-service']
                        for (service in services) {
                            sh "kubectl apply -f k8s/${service}-mysql-deployment.yaml --kubeconfig=${kubeconfig}"
                            sh "kubectl apply -f k8s/${service}-deployment.yaml --kubeconfig=${kubeconfig}"
                        }
                    }
                }
            }
        }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         script {
        //             withCredentials([file(credentialsId: 'kubeconfig', variable: 'kubeconfig')]) {
        //                 def services = ['user-service', 'product-service', 'order-service']
        //                 for (service in services) {
        //                     sh "kubectl apply -f k8s/${service}-deployment.yaml --kubeconfig=${kubeconfig}"
        //                 }
        //             }
        //             // def services = ['user-service', 'product-service', 'order-service']
        //             // for (service in services) {
        //             //     sh "kubectl set image deployment/${service}-deployment ${service}=${DOCKER_IMAGE}-${service}:latest --kubeconfig=${KUBE_CONFIG}"
        //             // }
        //         }
        //     }
        // }
    }

    //  post {
    //     always {
    //         cleanWs()
    //     }
    // }
}
