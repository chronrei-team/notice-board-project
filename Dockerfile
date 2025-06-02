FROM tomcat:11.0-jdk21-temurin-jammy
LABEL authors="soo_mini"

COPY target/notice-board-project-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]