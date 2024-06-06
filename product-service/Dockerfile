FROM openjdk:11
WORKDIR /app
COPY "target/product-service.jar" "product-service.jar"
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "product-service.jar"]