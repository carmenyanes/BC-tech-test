pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = env.AWS_ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY = env.AWS_SECRET_ACCESS_KEY
        AWS_DEFAULT_REGION    = 'us-east-1'
        ECR_REPOSITORY_NAME   = env.ECR_REPOSITORY_NAME
        EKS_CLUSTER_NAME      = env.EKS_CLUSTER_NAME
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    dir('microservice') {
                        sh 'docker build -t $ECR_REPOSITORY_NAME:latest .'
                    }
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                                 string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        sh 'aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com'
                        sh 'docker tag $ECR_REPOSITORY_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest'
                        sh 'docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest'
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $EKS_CLUSTER_NAME'
                        sh 'kubectl apply -f k8s/microservice/deployment.yaml'
                        sh 'kubectl apply -f k8s/microservice/service.yaml'
                    }
                }
            }
        }
    }
}
