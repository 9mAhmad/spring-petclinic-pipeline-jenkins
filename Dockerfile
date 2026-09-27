FROM alpine/java:22-jdk AS builder


WORKDIR /app
# 1. Copy ONLY the files needed to fetch dependencies
COPY .mvn .mvn
COPY mvnw pom.xml ./

# 2. Download dependencies (This layer WILL BE CACHED unless pom.xml changes)
RUN ./mvnw dependency:go-offline -B

# 3. Copy the rest of the source code
COPY src ./src

# 4. Build the application package (Skip 'clean' since it's a fresh container)
RUN ./mvnw package -DskipTests



# --------------------------------------

FROM alpine/java:21-jre  AS prod

RUN adduser --disabled-password jre_user

WORKDIR /app

COPY --from=builder --chown=jre_user:jre_user /app/target/*.jar ./app.jar

# RUN java -jar JtSpringProject-0.0.1-SNAPSHOT.jar 

EXPOSE 8080

ENTRYPOINT ["java", "-jar"]

CMD ["app.jar"]


# docker build -t ecommerce_java_mvn:v1.0notest -f ./Dockerfile ./
# docker build -t ecommerce_java_mvn:v1.1notest -f ./Dockerfile ./
# docker build -t ecommerce_java_mvn:v1.1notestwar -f ./Dockerfile ./
# docker run -dit -p 8080:8080 --name ecommerce_java ecommerce_java_mvn:v1.0notest
# docker run -dit -p 8080:8080 --name ecommerce_java_war ecommerce_java_mvn:v1.1notestwar
# docker run -dit -p 8080:8080 --name ecommerce_java_war ecommerce_java_mvn:v1.2