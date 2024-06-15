FROM openjdk
WORKDIR /app
ADD "target/user-service.jar" "user-service.jar"
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "user-service.jar"]