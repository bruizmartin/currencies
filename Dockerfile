ARG JRE_VERSION="25-jre"
FROM eclipse-temurin:${JRE_VERSION}

ARG APP_VERSION="0.0.2-SNAPSHOT"
ENV APP_VERSION=${APP_VERSION}

WORKDIR /currencies
COPY build/libs/currencies-${APP_VERSION}.jar currencies-${APP_VERSION}.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -jar /currencies/currencies-${APP_VERSION}.jar"]
