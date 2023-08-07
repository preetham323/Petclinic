FROM openjdk:17-oracle
RUN mkdir -p /home/petclinic

COPY target/*.jar /home/petclinic/

WORKDIR /home/petclinic/

EXPOSE 8282

ARG VALUE="not set"

ENV MYSQL_URL=${VALUE}

CMD ["java", "-jar", "spring-petclinic-3.1.0-SNAPSHOT.jar", "--spring.profiles.active=mysql"]