# Use an official Tomcat runtime as a base image
FROM tomcat:8.0.20-jre8

# Remove the default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file into the container
COPY /target/fs-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port Tomcat will run on
EXPOSE 8080

# Define the command to run Tomcat
CMD ["catalina.sh", "run"]