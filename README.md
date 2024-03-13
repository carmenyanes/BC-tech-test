# BC-tech-test

A continuación se presenta la prueba técnica realizada para el despliegue de una infraestructura utilizando Terraform, la configuración de Jenkins y SonarQube en un clúster de Kubernetes y un microservicio en otro clúster.


##Descripción
El objetivo de esta prueba técnica es levantar dos clústeres en Kubernetes utilizando Terraform, uno de deployment y otro de development. Estos clústeres permitirán desplegar un "hello-world" en Java 17 e integrar herramientas como Jenkins y SonarQube


###Prerrequisitos. 

1. Terraform instalado 
2. kubectl instalado 
3. Tener una cuenta de AWS 
4. Tener configuradas localmente las credenciales de la cuenta de AWS donde se va a desplegar la infraestructura


###Intrucciones 

```git clone https://github.com/carmenyanes/BC_tech-test.git```
```cd BC_tech-test```


##Creación de clusters de kubernetes en EKS (Elastic Kubernetes Service)

###Creación de cluster de deployment

1. Inicializar Terraform y validar la configuración:


```
terraform init -var-file="deployment.tfvars"
terraform validate
```

2. con terraform plan revisar lo que se va a desplegar y luego con terraform apply con la flag -auto-approve desplegar lo ya previsto en terraform plan 

```
terraform plan -var-file="deployment.tfvars"
terraform apply -var-file="deployment.tfvars" -auto-approve
```


###Creación de cluster de development



