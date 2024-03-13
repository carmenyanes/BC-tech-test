pipeline {
  agent any

  parameters {
    string(name: 'AWS_ACCESS_KEY_ID', defaultValue: '${env.AWS_ACCESS_KEY_ID}', description: 'AWS Access Key ID')
    string(name: 'AWS_SECRET_ACCESS_KEY', defaultValue: '${env.AWS_SECRET_ACCESS_KEY}', description: 'AWS Secret Access Key')
    string(name: 'AWS_DEFAULT_REGION', defaultValue: 'us-east-1', description: 'AWS Default Region')
    string(name: 'ECR_REPOSITORY_NAME', defaultValue: '${env.ECR_REPOSITORY_NAME}', description: 'Nombre del repositorio ECR')
    string(name: 'EKS_CLUSTER_NAME', defaultValue: 'development_demo', description: 'Nombre del cluster EKS')
  }

  stages {
    stage('Build Docker Image') {
      steps {
        script {
          docker.build(
            imageName: "${ECR_REPOSITORY_NAME}:latest",
            dockerfilePath: 'microservice/Dockerfile',
            buildContext: 'microservice'
          )
        }
      }
    }

    stage('Push Docker Image to ECR') {
      steps {
        script {
          docker.withRegistry('https://${AWS_DEFAULT_REGION}.dkr.ecr.aws.amazon.com', credentialsId: 'aws-ecr-credentials') {
            push("${ECR_REPOSITORY_NAME}:latest")
          }
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        script {
          def livenessProbe = [
            initialDelaySeconds: 5,
            periodSeconds: 10,
            timeoutSeconds: 5,
            successThreshold: 1,
            failureThreshold: 3
          ]
          def readinessProbe = [
            initialDelaySeconds: 5,
            periodSeconds: 10,
            timeoutSeconds: 5,
            successThreshold: 1,
            failureThreshold: 3
          ]

          kubernetesDeploy(
            kubectl: 'kubectl',
            containerImage: "${ECR_REPOSITORY_NAME}:latest",
            namespace: 'microservice',
            serviceName: 'microservice',
            deploymentName: 'microservice',
            replicas: 2,
            nodeSelector: '',
            podLabels: '',
            containerPort: 8000,
            servicePort: 8000,
            livenessProbe: livenessProbe,
            readinessProbe: readinessProbe
          )
        }
      }
    }
  }
}
