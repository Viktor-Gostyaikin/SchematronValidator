# https://github.com/carlossg/docker-maven/blob/956a0125d92bef7f4c68831eee31d0070827bd06/libericaopenjdk-17-alpine/Dockerfile
FROM bellsoft/liberica-openjdk-alpine:17

RUN apk add --no-cache bash procps curl tar

# common for all images
ENV MAVEN_HOME /usr/share/maven

COPY --from=maven:3.9.6-eclipse-temurin-11 ${MAVEN_HOME} ${MAVEN_HOME}
COPY --from=maven:3.9.6-eclipse-temurin-11 /usr/local/bin/mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY --from=maven:3.9.6-eclipse-temurin-11 /usr/share/maven/ref/settings-docker.xml /usr/share/maven/ref/settings-docker.xml

RUN ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

ARG MAVEN_VERSION=3.9.6
ARG USER_HOME_DIR="/root"
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

RUN ["/usr/local/bin/mvn-entrypoint.sh"]

# Развертывание проекта
COPY src /project/src
WORKDIR /project

COPY pom.xml /project/pom.xml

RUN ["mvn", "clean", "verify"]
CMD ["mvn", "spring-boot:run"]