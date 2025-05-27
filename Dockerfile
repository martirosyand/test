# Use openjdk 17 slim version image
FROM openjdk:17-slim 

# Set the working directory
WORKDIR /app


# Copy application source folder into maven directory
COPY target/spring*.jar .

# Rename SNAPSHOT
RUN mv spring*.jar app.jar

# Expose the port the application will run on
EXPOSE 8080

# Run java application
ENTRYPOINT ["java", "-jar", "app.jar"]
