# Stage 1: Build Maven project
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app

# Copy only the pom.xml file to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the entire project and build it
COPY . .
RUN mvn package

# Stage 2: Create a lightweight image with Tomcat
FROM tomcat:9.0-jdk11-openjdk-slim
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file from the build stage to Tomcat's webapps directory
COPY --from=build /app/target/fs-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/fs.war

# Expose the port Tomcat will run on
EXPOSE 8080

# Define the command to run Tomcat
CMD ["catalina.sh", "run"]
