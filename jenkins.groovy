pipeline {
    agent any

    environment {

        IMAGE_TAG = "${env.BUILD_NUMBER}"
        PREVIOUS_TAG = "${env.BUILD_NUMBER.toInteger() - 1}"
        PROJECT_NAME = "petclinic"
        PORT_INTERNAL = "8080"
        PORT_EXTERNAL = "8090"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Clone React Job Portal Frontend from Main Branch"

                git branch: 'main', url: 'https://github.com/9mAhmad/spring-petclinic-pipeline-jenkins.git'

                sh 'ls -lah'
            }
        }
        stage ('compose up containers...'){
            
            steps{
                sh """
                    # first compose down if any.

                    docker compose down -v && \
                    docker ps -a
                    docker compose up -d
                """
            }
        }
        
        stage ('Check the backend\'s logs'){
            steps{
                sh "docker ps -a"
                sh "docker logs petclinic_java"
            }
        }
    }
}
