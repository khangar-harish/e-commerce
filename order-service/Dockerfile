FROM openjdk
WORKDIR /app
COPY "target/order-service.jar" "order-service.jar"
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "order-service.jar"]