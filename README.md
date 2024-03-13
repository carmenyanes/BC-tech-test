# Prueba técnica | Ingeniero DevOps 

A continuación se presenta la prueba técnica realizada para el despliegue de una infraestructura utilizando Terraform, la configuración de Jenkins y SonarQube en un clúster de Kubernetes y un microservicio en otro clúster.


## Descripción
El objetivo de esta prueba técnica es levantar dos clústeres en Kubernetes utilizando Terraform, uno de deployment y otro de development. Estos clústeres permitirán desplegar un "hello-world" en Java 17 e integrar herramientas como Jenkins y SonarQube.


### Prerrequisitos. 

1. Terraform instalado 
2. kubectl instalado 
3. Tener una cuenta de AWS 
4. Tener configuradas localmente las credenciales de la cuenta de AWS donde se va a desplegar la infraestructura


### Intrucciones 

```
git clone https://github.com/carmenyanes/BC_tech-test.git
cd BC_tech-test
```


## Creación de clusters de kubernetes en EKS (Elastic Kubernetes Service)

### Creación de cluster de deployment

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

Se deben esperar unos minutos a que se despliegue completamente la infraestructura. 


3. Al levantar el cluster de deployment vamos a proceder a agregar Jenkins a nuestro cluster. Primero, nos vamos a conectar al cluster de deployment que acabamos de levantar, llamado "deployment_demo"  y luego nos vamos a ubicarnos en el directorio directorio de jenkins.

```
aws eks --region us-east-1 update-kubeconfig --name deployment_demo
cd k8s/jenkins
```

4. Creamos un namespace nuevo. 

```
kubectl create namespace devops-tools
```

5. creamos el service account para jenkins. 

```
kubectl apply -f serviceAccount.yaml
```

6. Para la creación del volumen tenemos que sustituir el valor del worker node en la línea 32 del archivo volume.yaml, obtenemos el valor del worker node 

```
kubectl get nodes
```

7. al reemplazar el worker node, vamos a crear el volumen 

```
kubectl create -f volume.yaml
```

8. Ahora, creamos el deployment de jenkins. 

```
kubectl apply -f deployment.yaml
```

Si se quiere revisar el estado del deployment o detalles del mismo

```
kubectl get deployments -n devops-tools
kubectl describe deployments --namespace=devops-tools
```

9. Cuando tenemos nuestro deployment de jenkins ready, creamos el load balancer para que jenkins pueda ser accesado desde el exterior. 


```
kubectl apply -f jenkins-lb.yaml
```


para ver el status del load balancer 

```
kubectl describe service public-lb -n devops-tools
```


### Configuración de jenkins 

Para acceder a jenkins vamos a utilizar ingresar en el puerto 8080 en la URL pública que se puede obtener de AWS. 


Al ingresar a jenkins desde el navegador web se solicitará una contraseña. Para encontrar esa ontraseña vamos a obtener primero el nombre del pod de jenkis con el siguiente comando, normalmente inicia con jenkins-...

```
kubectl get pods --namespace=devops-tools
```


Al tener el nombre del pod, vamos a correr el siguiente comando y vamos a obtener la contraseña que necesita jenkins como output. 

```
kubectl exec -it <nombre-de-tu-pod> cat /var/jenkins_home/secrets/initialAdminPassword -n devops-tools
```


Documentación para integrar GitHub con jenkins: 
https://www.cprime.com/resources/blog/how-to-integrate-jenkins-github/


### Configuración de SonarQube 

1. Nos ubicamos en el directorio de k8s/sonarqube y creamos un namespace nuevo. 

```
cd k8s/sonarqube
kubectl create namespace sonarqube
```

2. Corremos el deployment y service de sonarqube. 

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Para acceder a sonarqube se obtendrá la URL desde AWS, y el puerto será el 9000. 
Al ingresar a sonarqube desde el navegador web se pedirán unas credenciales las cuales son el user y la contraseña respectivamente: admin / admin 





### Creación de cluster de development



1. Inicializar Terraform y validar la configuración:

```
terraform init -var-file="development.tfvars"
terraform validate
```

2. Con el comando terraform plan revisar la infraestructura y luego con terraform apply con la flag -auto-approve desplegar lo ya previsto en terraform plan.

```
terraform plan -var-file="development.tfvars"
terraform apply -var-file="development.tfvars" -auto-approve
```

Se deben esperar unos minutos a que se despliegue completamente la infraestructura. 


3. Al levantar el cluster de deployment vamos a proceder a hacer el primer despliegue manual de nuestro hello-world con java 17. Para eso, vamos a crear un ECR para almacenar la imagen de docker y nos vamos a autenticar en el registry para poder subir desde local la imagen de docker. 


```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS-account-ID>.dkr.ecr.us-east-1.amazonaws.com
```

Nota: Si hay un mensaje de error usando el AWS CLI, nos vamos a asegurar de tener la última versión y docker instalado.

4. Corremos los comandos para hacer el build de la imagen de docker del microservicio, agregamos la tag latest y el nombre del repositorio y lo subimos

```
docker build -t development .
docker tag development:latest <nombre-de-tu-repositorio>:latest
docker push <nombre-de-tu-repositorio>:latest
```

5. Ahora que hemos subido la imagen de docker del microservicio, n ubicamos en el directorio del mismo.

```
cd k8s/microservice 
```


6. Creamos los secretos con el siguiente comando, reemplazando los valores de 'your-access-key-id' y 'your-secret-access-key' por los de nuestra cuenta de AWS. 

kubectl create secret generic aws-ecr-credentials \
    --from-literal=AWS_ACCESS_KEY_ID=your-access-key-id \
    --from-literal=AWS_SECRET_ACCESS_KEY=your-secret-access-key


7. Corremos el deployment (que creará 2 réplicas del microservicio ) y creamos el load balancer dentro del cluster de kubernetes. (vamos a reemplazar la variable, por el nombre de nuestro repositorio)

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

para poder acceder a nuestro microservicio vamos a obtener la URL de AWS y vamos a ingresar con el puerto 8080. 