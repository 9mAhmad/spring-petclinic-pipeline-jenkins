FROM alpine/java:22-jdk AS builder


WORKDIR /app

COPY . .


# RUN mvn clean package -DskipTests # compiles the tests but does not run tests

RUN ./mvnw clean package -Dmaven.test.skip=true # does not compile nor run the tests.

# RUN bash -c "ls -1R ./target/"

RUN ls -l

RUN pwd

# --------------------------------------

FROM alpine/java:21-jre  AS prod

RUN adduser --disabled-password jre_user

WORKDIR /app

COPY --from=builder --chown=jre_user:jre_user /app/target/*.jar ./app.jar

# RUN java -jar JtSpringProject-0.0.1-SNAPSHOT.jar 

EXPOSE 8080

ENTRYPOINT ["java", "-jar"]

CMD ["JtSpringProject-0.0.1-SNAPSHOT.war"]


# docker build -t ecommerce_java_mvn:v1.0notest -f ./Dockerfile ./
# docker build -t ecommerce_java_mvn:v1.1notest -f ./Dockerfile ./
# docker build -t ecommerce_java_mvn:v1.1notestwar -f ./Dockerfile ./
# docker run -dit -p 8080:8080 --name ecommerce_java ecommerce_java_mvn:v1.0notest
# docker run -dit -p 8080:8080 --name ecommerce_java_war ecommerce_java_mvn:v1.1notestwar
# docker run -dit -p 8080:8080 --name ecommerce_java_war ecommerce_java_mvn:v1.2