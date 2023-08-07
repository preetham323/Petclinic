pipeline {
    agent any
    tools {
        maven "maven3"
    }
    environment {
        registryCredentials = 'ecr:us-east-2:aws_credential'
        appRegistry = "346141603601.dkr.ecr.us-east-2.amazonaws.com/petclinic"
        petclinicRegistry = "https://346141603601.dkr.ecr.us-east-2.amazonaws.com"
        SONAR_TOKEN = credentials('SONAR_TOKEN')
    }
    stages {
        stage ('fetch code') {
            steps {
                git branch: 'petclinic', url: 'https://github.com/preetham323/Petclinic.git'
            }
        }
        stage ('test') {
            steps {
                sh 'mvn test'
            }
        }
        stage ('code analysis with checkstyle') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'General analysis report'
                }
            }
        }
        stage ('build & Sonarqube analysis') {
            steps {
                script {
                    echo 'scanning code'
                    env.SONAR_TOKEN = "${SONAR_TOKEN}"
                    sh 'mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=pree-projects_pree-project'
                }
            }
        }
        stage ('build app image') {
            steps {
                script {
                    sh "docker build -t preepetclincimg:$BUILD_NUMBER ."
                }
            }
        }
        stage ('upload App Image') {
            steps {
                script {
                    docker.withRegidtry(petclinicRegistry, registryCredentials) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest') 
                    }
                }
            }
        }
    }
}