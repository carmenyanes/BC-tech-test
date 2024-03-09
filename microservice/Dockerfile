FROM openjdk:17-alpine

WORKDIR /usr/src/app

COPY HelloWorld.java .

RUN javac HelloWorld.java

CMD ["java", "HelloWorld"]

EXPOSE 8000
